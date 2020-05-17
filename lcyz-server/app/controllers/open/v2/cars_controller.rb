module Open
  module V2
    class CarsController < Open::ApplicationController
      def index
        param! :order_field, String,
               default: "id",
               in: %w(id stock_age_days online_price_cents age mileage
                      name_pinyin show_price_cents available created_at brand_name
                      onsale_price_cents)
        param! :order_by, String, in: %w(asc desc), default: "desc"
        param! :query, Hash
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 25

        cars_scope = if params[:with_all]
                       current_company_cars
                         .includes(:acquisition_transfer, :company)
                     else
                       current_company_cars
                         .includes(:acquisition_transfer, :company)
                         .where(sellable: true)
                     end

        cars = paginate cars_scope.state_in_stock_scope.ransack(params[:query]).result

        cars_count = cars.total_count

        cars = order_scope(cars)

        render json: {
          data: cars.ids,
          per_page: params[:per_page],
          total: cars.total_count,
          cars_count: cars_count
        }
      end

      def fetch_by_ids
        cars = Car.where(id: params[:ids])

        render json: cars,
               each_serializer: CarSerializer::OpenDetail,
               root: "data"
      end

      def subscribe
        car = Car.find(params[:car_id])

        service = Intention::CreateService.new(
          seller,
          seller.company.intentions,
          intention_params(car)
        )
        service.execute

        if service.valid?
          render json: { message: :ok }, scope: nil
        else
          validation_error(service.errors)
        end
      end

      # rubocop:disable Metrics/AbcSize
      def similar
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 25

        car = Car.find(params[:car_id])
        return render(json: { data: [] }, scope: nil) unless car.online_price_wan

        cars = paginate current_company_cars
               .state_in_stock_scope
               .where("cars.id != ?", car.id)

        if params[:search_range] == "company_only"
          cars = cars.where(company_id: car.company_id)
        elsif params[:search_range] == "company_except"
          cars = cars.where.not(company_id: car.company_id)
        end

        cars = Car::SimilarService.new(cars).similar_to(car)

        render json: {
          data: cars.map(&:id),
          per_page: params[:per_page],
          total: cars.count
        }
      end
      # rubocop:enable Metrics/AbcSize

      def search
        # make it the car from that company
        cars = current_company_cars
        params.except(:controller, :action).each do |key, v|
          case key
          when "car_brand"
            cars = cars.where(brand_name: v)
          when "car_type", "emission_standard", "fuel_type", "transmission", "exterior_color"
            value = v.split(",").delete_if(&:blank?)
            cars = cars.where("#{key} in (?)", value)
          when "age", "mileage", "displacement", "online_price_cents"
            values = v.split(",").delete_if(&:blank?)
            query_string = []
            values.each do |scope|
              if key == "online_price_cents"
                min, max = scope.split("-").map { |n| n.to_i * 100 * 10000 }
              else
                min, max = scope.split("-")
              end
              query_string << "(#{key} > #{min})" if max == "0"
              query_string << "(#{key} > #{min} and #{key} < #{max})"
            end
            cars = cars.where(query_string.join(" or "))
          end
        end
        render json: cars,
               each_serializer: CarSerializer::OfficialSiteList,
               root: "data"
      end

      def ids_search
        param! :query, Hash

        cars = Car.where(id: params[:query][:id])
        render json: cars,
               each_serializer: CarSerializer::OfficialSiteList,
               root: "data"
      end

      def short_search
        param! :query, Hash

        name = params[:query][:search_name]
        value = params[:query][:search_vlaue]
        case name
        when "car_brand"
          cars = current_company_cars.where(brand_name: value)
        when "online_price_cents", "age"
          min, max = value.split("-").map { |n| n.to_i * 100 * 10000 }
          query_string = "(#{name} > #{min} and #{name} < #{max})"
          query_string = "(#{name} > #{min})" if max == "0"
          cars = current_company_cars.where(query_string)
        end

        render json: cars,
               each_serializer: CarSerializer::OfficialSiteList,
               root: "data"
      end

      # 根据car_id得到某辆车的老司机查询报告
      def insurance_record
        car_id = params[:car_id]

        car = Car.find_by(id: car_id)
        vin = car.try(:vin)
        hub = OldDriverRecordHub.where(vin: vin).last

        return render json: { data: nil }, scope: nil if hub.nil?

        render json: hub,
               serializer: OldDriverRecordHubSerializer::Detail,
               root: "data"
      end

      def detection_report
        car_id = params[:car_id]

        car = Car.find(car_id)
        report = car.detection_report

        if report
          render json: report,
                 serializer: DetectionReportSerializer::Detail,
                 root: "data"
        else
          render json: { data: nil }, scope: nil
        end
      end

      def maintenance_summary
        @car = current_company_cars.find(params[:id])
        return render(json: { data: [] }, scope: nil) unless @car
        @record = MaintenanceRecord.where(car_id: @car.id).order(:created_at).last
        return render(json: { data: [] }, scope: nil) unless @record

        render json: @record,
               serializer: MaintenanceRecordSerializer::Summary,
               root: "data"
      end

      def maintenance_detail
        @car = current_company_cars.find(params[:id])
        return render(json: { data: [] }, scope: nil) unless @car
        @record = MaintenanceRecord.where(car_id: @car.id).order(:created_at).last
        return render(json: { data: [] }, scope: nil) unless @record

        render json: @record,
               serializer: MaintenanceRecordSerializer::Detail,
               root: "data"
      end

      # 对车辆信息进行编辑
      def update
        car = current_company_cars.find(params[:id])
        car.update!(car_params)

        render json: car,
               serializer: CarSerializer::OpenDetail,
               root: "data"
      end

      private

      def car_params
        params.require(:car).permit(:sellable)
      end

      def order_scope(cars)
        if params[:available_first].present?
          cars = cars.order(
            <<-SQL.squish!
              CASE WHEN cars.cover_url IS NULL OR cars.show_price_cents IS NULL THEN NULL
                ELSE 1
              END DESC NULLS LAST
            SQL
          )
        end

        if params[:favored_company_id].present?
          favored_company_id = params[:favored_company_id].scan(/\d+/).first.to_i

          cars = cars.order(
            <<-SQL.squish!
              CASE cars.company_id
              WHEN '#{favored_company_id}' THEN 0
              ELSE 1 END
            SQL
          )
        end

        order_field = params[:order_field] == "id" ? "cars.id" : "cars.#{params[:order_field]}"
        order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"
        cars.order("#{order_field} #{order_by}")
      end

      def buyer_appointment_params
        params.require(:buyer_appointment).permit(:customer_name, :customer_phone, :seller_id)
      end

      def seller
        unless @seller
          scrapped_params = buyer_appointment_params
          seller_id = scrapped_params[:seller_id] || params[:seller_id]
          @seller = if User.exists?(seller_id)
                      User.find(seller_id)
                    else
                      User::Anonymous.new(company: current_company)
                    end
        end
        @seller
      end

      def intention_params(car)
        scrapped_params = buyer_appointment_params
        {}.tap do |hash|
          hash[:customer_name] = scrapped_params[:customer_name]
          hash[:customer_phone] = scrapped_params[:customer_phone]
          hash[:assignee_id] = seller.id # 微信分享人
          hash[:creator_id] = seller.id
          hash[:creator_type] = "User"
          hash[:intention_type] = :seek

          hash[:source_car_id] = car.id
          hash[:source_company_id] = car.company_id
          hash[:seeking_cars] = [
            {
              brand_name: car.brand_name,
              series_name: car.series_name,
              style_name: car.style_name
            }
          ]
        end
      end
    end
  end
end
