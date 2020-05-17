module Open
  class DetectionController < ActionController::API
    include ErrorCollector::Handler

    rescue_from ActiveRecord::RecordNotFound do |_e|
      render(status: 404, json: { data: "相关信息未配置" }, scope: nil)
    end

    # 从壁虎导入车辆信息，创建入库, 创建检测报告
    def create
      param! :key, String, required: true
      param! :c_code, String, required: true

      validate_detection_config!

      car = Car.where(company_id: company.id).new(constructed_car_params)

      car = Car::CreateService.new(
        owner, car, acquisition_transfer_params, {}
      ).execute.car

      if car.errors.empty?
        car.create_detection_report(
          constructed_report_params
        )
        render json: { data: { car_id: car.id } }, scope: nil
      else
        validation_error(full_errors(car))
      end
    rescue Car::CreateService::InvalidVinError => _
      validation_error(full_errors(car))
    end

    private

    def validate_detection_config!
      key = params[:key]
      c_code = params[:c_code]

      @detection_config = DetectionConfig.where(key: key, c_code: c_code).first

      raise ActiveRecord::RecordNotFound unless @detection_config
    end

    def company
      @_company ||= Company.find(@detection_config.c_id)
    end

    def owner
      @_owner ||= company.owner
    end

    def shop
      @_shop ||= company.find_or_create_shop(params[:shop_name])
    end

    def constructed_car_params
      car_params.merge(
        name: car_params.values_at(:brand_name, :series_name, :style_name).join(" "),
        acquisition_type: :acquisition,
        license_info: :licensed,
        acquirer_id: owner.id,
        shop_id: shop.id,
        acquired_at: Time.zone.now,
        show_price_wan: car_params[:online_price_wan],
        sales_minimun_price_wan: car_params[:alliance_minimun_price_wan],
        manager_price_wan: 0,
        acquisition_price_wan: 0
      )
    end

    def car_params
      params.require(:car).permit(
        :brand_name, :series_name, :style_name,
        :vin, :manufactured_at, :mileage, :displacement,
        :licensed_at, :exterior_color, :interior_color, :online_price_wan,
        :alliance_minimun_price_wan, :allowed_mortgage,
        images_attributes: [:url, :is_cover]
      ).tap do |white_listed|
        if white_listed[:images_attributes]
          white_listed[:images_attributes].map do |image_attr|
            image_attr.merge!(is_cover: false)
          end

          white_listed[:images_attributes].first[:is_cover] = true
        end

        white_listed
      end
    end

    def acquisition_transfer_params
      params.require(:car).permit(
        :compulsory_insurance_end_at, :annual_inspection_end_at
      )
    end

    def constructed_report_params
      report_params.merge(
        report_type: :report,
        platform_name: @detection_config.platform_name
      )
    end

    def report_params
      params.require(:report).permit(
        :url
      )
    end

    def validation_error(errors)
      hash = {
        message: "参数校验不通过",
        errors: errors
      }

      render(json: hash, status: 422, scope: nil)
    end
  end
end
