# 联盟公司车辆controller
module V1
  module AllianceDashboard
    class CarsController < V1::AllianceDashboard::ApplicationController
      def index
        basic_params_validations
        param! :order_field, String,
               default: "id",
               in: %w(
                 id stock_age_days show_price_cents age
                 mileage name_pinyin acquired_at stock_out_at
               )

        order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

        scope = current_company.cars.includes(
          :acquisition_transfer, :shop, :acquirer,
          :cover, :car_reservation, :operation_records
        )

        cars = paginate scope
               .state_in_stock_scope
               .ransack(params[:query]).result.uniq
               .order("cars.#{params[:order_field]} #{order_by}")
               .order(id: :desc)

        render json: cars,
               nickname: true,
               alliance_images: true,
               each_serializer: CarSerializer::AllianceInStockList,
               root: "data"
      end

      def show
        render json: current_company.cars.find(params[:id]),
               alliance_images: true,
               serializer: CarSerializer::Detail,
               root: "data", include: "**"
      end

      def edit
        car = current_company.cars.find(params[:id])
        authorize car

        render json: car,
               nickname: true,
               serializer: CarSerializer::Edit,
               root: "data",
               include: "**"
      end

      def update
        car = current_company.cars.find(params[:id])
        authorize car

        service = Car::UpdateService.new(
          current_user, car, car_params, acquisition_transfer_params, {}
        ).execute

        if service.valid?
          render json: service.car,
                 serializer: CarSerializer::Detail,
                 root: "data", include: "**"
        else
          validation_error(service.errors)
        end
      end

      def update_images
        car = Car.find(params[:id])
        car.update(car_params)

        render json: car,
               alliance_images: true,
               serializer: CarSerializer::InStockList,
               root: "data"
      end

      def images_download
        param! :download_type,
               String,
               in: %w(car transfer),
               transform: :downcase,
               default: "transfer"

        car = current_company.cars.find(params[:id])

        urls = download_urls(car, params[:download_type], params[:image_type])
        return render nothing: true, status: 204 if urls.length <= 0

        @download_service = Car::ImagesDownloadService.new(current_user, car, urls)
        zip_file, io = @download_service.download

        send_data(io.string, type: "application/zip", filename: zip_file)
      end

      def out_of_stock
        basic_params_validations
        param! :order_field, String,
               default: "stock_out_at",
               in: %w(id stock_out_at stock_age_days show_price_cents age mileage
                      name_pinyin)

        order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"
        # eager load 会自动 left outer join stock_out_inventories
        scope = current_company.cars.includes(
          :acquisition_transfer, :shop, :acquirer,
          :cover, :car_reservation
        )

        cars = paginate scope
               .state_out_of_stock_scope
               .includes(
                 { stock_out_inventory: [:seller, :operator] },
                 :cover, :acquirer, :shop, :acquisition_transfer, :sale_transfer
               ).ransack(params[:query]).result
               .order("cars.#{params[:order_field]} #{order_by}")
               .order("cars.id desc, cars.updated_at desc")

        render json: cars,
               nickname: true,
               alliance_images: true,
               each_serializer: CarSerializer::OutOfStockList,
               root: "data",
               include: "**"
      end

      private

      def download_urls(car, download_type, image_type)
        if download_type == "car"
          {
            "water_mark" => -> { water_mark_urls(car) },
            "original" => -> { car.images.map(&:url) },
            "alliance" => -> { car.alliance_images.map(&:url) },
            "alliance_watermark" => -> { water_mark_urls(car, "alliance_images") }
          }.fetch(image_type).call
        else
          car.acquisition_transfer.images.map(&:url)
        end
      end

      def water_mark_urls(car, category = "car_image")
        alliance_company = car.company.alliance_company
        return car.images.map(&:url) if alliance_company.blank?

        if category == "car_image"
          water_mark(car.images, alliance_company)
        elsif category == "alliance_images"
          water_mark(car.alliance_images, alliance_company)
        end
      end

      def water_mark(images, alliance_company)
        images.map do |image|
          image.with_water_mark(
            alliance_company.water_mark_position,
            alliance_company.water_mark
          )
        end
      end

      def current_company
        current_user.alliance_company
      end

      def car_params
        params.require(:car).permit(
          { attachments: [] }, :sellable, :name, :is_special_offer, :fee_detail,
          :acquirer_id, :acquired_at, :channel_id, :acquisition_type, :shop_id,
          :acquisition_price_wan, :stock_number, :vin, :state, :state_note,
          :brand_name, :manufacturer_name, :series_name, :style_name, :car_type,
          :door_count, :displacement, :is_turbo_charger, :fuel_type, :transmission,
          :exterior_color, :interior_color, :mileage, :red_stock_warning_days,
          :emission_standard, :license_info, :licensed_at, :manufactured_at, :level,
          :show_price_wan, :online_price_wan, :sales_minimun_price_wan, :mileage_in_fact,
          :manager_price_wan, :alliance_minimun_price_wan, :new_car_guide_price_wan,
          :new_car_additional_price_wan, :new_car_discount, :new_car_final_price_wan,
          :interior_note, :star_rating, :warranty_id, :warranty_fee_yuan, :is_fixed_price,
          :allowed_mortgage, :mortgage_note, :selling_point, :maintain_mileage,
          :has_maintain_history, :new_car_warranty, :yellow_stock_warning_days,
          :consignor_name, :consignor_phone, :consignor_price_wan, :configuration_note,
          { images_attributes: [:id, :url, :location, :sort, :is_cover, :_destroy] },
          { alliance_images_attributes: [:id, :url, :location, :sort, :is_cover, :_destroy] },
          cooperation_company_relationships_attributes: [
            :id, :cooperation_company_id, :cooperation_price_wan, :_destroy
          ]
        ).tap do |white_listed|
          manufacturer_configuration = params[:car][:manufacturer_configuration]

          if manufacturer_configuration
            white_listed[:manufacturer_configuration] = manufacturer_configuration
          end
        end
      end

      def acquisition_transfer_params
        return {} unless params[:acquisition_transfer].present?

        params.require(:acquisition_transfer).permit(
          :key_count, :compulsory_insurance_end_at, :commercial_insurance_end_at,
          :commercial_insurance_amount_yuan, :annual_inspection_end_at,
          :compulsory_insurance, :commercial_insurance, :current_plate_number,
          images_attributes: [
            :id, :url, :location, :sort, :is_cover, :_destroy
          ]
        )
      end
    end
  end
end
