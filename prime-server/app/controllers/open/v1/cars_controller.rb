module Open
  module V1
    class CarsController < Open::ApplicationController
      def index
        param! :order_field, String,
               default: "id",
               in: %w(id stock_age_days online_price_cents age mileage
                      name_pinyin show_price_cents available)
        param! :order_by, String, in: %w(asc desc), default: "desc"
        param! :query, Hash
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 25

        cars = paginate current_company_cars
               .includes(:acquisition_transfer, :company)
               .where(sellable: true, reserved: false).state_in_stock_scope
               .ransack(params[:query]).result
        cars = order_scope(cars)

        alliance_company = current_company.alliance_company

        render json: cars,
               each_serializer: CarSerializer::Open,
               alliance_company: alliance_company,
               root: "data",
               meta: {
                 "X-Per-Page" => params[:per_page],
                 "X-Total" => cars.total_count,
                 "version_catagory" => version_catagory
               }
      end

      def show
        car = Car.find(params[:id])
        alliance_company = car.company.alliance_company

        render json: car,
               serializer: CarSerializer::OpenDetail,
               alliance_company: alliance_company,
               root: "data",
               meta: { version_catagory: version_catagory }
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

      def price_similar
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 25

        car = Car.find(params[:car_id])
        return render(json: { data: [] }, scope: nil) unless car.online_price_wan

        cars = paginate current_company_cars
               .state_in_stock_scope
               .where("cars.id != ?", car.id)
               .includes(:cover, :acquisition_transfer, :company)
               .order("reference asc, online_price_cents asc")
               .select(
                 <<-SQL.squish!
                   cars.*,
                   abs(cars.online_price_cents - #{car.online_price_cents}) AS reference
                 SQL
               )

        render json: cars,
               each_serializer: CarSerializer::Open,
               root: "data",
               meta: { version_catagory: version_catagory }
      end

      def similar
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 25

        car = Car.find(params[:car_id])
        return render(json: { data: [] }, scope: nil) unless car.online_price_wan

        cars = paginate current_company_cars
               .state_in_stock_scope
               .where("cars.id != ?", car.id)
               .includes(:cover, :acquisition_transfer, :company)

        cars = cars.where.not(company_id: car.company_id) unless params[:without_allied]

        render json: Car::SimilarService.new(cars).similar_to(car),
               each_serializer: CarSerializer::Open,
               root: "data",
               meta: { version_catagory: version_catagory }
      end

      private

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
