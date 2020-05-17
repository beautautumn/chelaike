module AcquisitionCarInfoService
  class Confirmation
    include ErrorCollector

    attr_accessor :confirmation, :info, :car

    def initialize(user, acquisition_car_info)
      @user = user
      @info = acquisition_car_info
    end

    def create(acquisition_confirmation_params)
      self_acquisition = self_acquisition?(acquisition_confirmation_params)
      acquisition_confirmation_params = sanitized(acquisition_confirmation_params)

      @confirmation = @info.build_acquisition_confirmation(acquisition_confirmation_params)

      fallible @confirmation, @info

      begin
        @info.transaction do
          execute_confirmation
          @car = execute_car(self_acquisition).car
          @info.update!(
            state: "finished",
            car_id: @car.id,
            closing_cost_wan: @confirmation.acquisition_price_wan
          )
        end
      rescue ActiveRecord::RecordInvalid
        @confirmation
      end

      self
    end

    private

    def execute_confirmation
      @confirmation.save!
    end

    def execute_car(self_acquisition)
      car_images, acquisition_images = images_attrs
      total_params = info_attrs.merge(confirmation_attrs)
                               .merge(acquisition_type: "acquisition")
                               .with_indifferent_access

      acquisition_transfer_params = total_params.slice(:key_count)
                                                .merge(images_attributes: acquisition_images)

      car_params = total_params.merge(images_attributes: car_images)
                               .slice!(:key_count, :images)

      car = Car.where(company_id: @confirmation.company_id).new(car_params)
      Car::CreateService.new(
        @user, car, acquisition_transfer_params
      ).acquisition_create(self_acquisition)
    end

    def images_attrs
      images = info_attrs.fetch("images")
      car_images = select_images_type(images, "car")
      acquisition_images = select_images_type(images, "drive_licence").map do |image_attr|
        image_attr.merge("location" => "driving_license")
      end

      [car_images, acquisition_images]
    end

    def select_images_type(images, type)
      images.select { |image| image.fetch("type") == type }
            .map { |image| image.except("type") }
    end

    def info_attrs
      @attrs ||= @info.attributes.slice(
        "brand_name", "series_name", "style_name", "acquirer_id",
        "licensed_at", "new_car_guide_price_cents", "new_car_final_price_cents",
        "manufactured_at", "mileage", "exterior_color", "interior_color",
        "displacement", "manufacturer_configuration", "key_count", "images"
      )

      @attrs["license_info"] = @info.licensed_at.present? ? "licensed" : "unlicensed"
      @attrs
    end

    def confirmation_attrs
      @confirmation.attributes.slice(
        "acquisition_price_cents", "acquired_at",
        "company_id", "shop_id"
      )
    end

    def sanitized(confirmation_params)
      return confirmation_params unless self_acquisition?(confirmation_params)

      confirmation_params.merge!(
        company_id: @user.company_id,
        shop_id: @user.shop_id
      )
    end

    def self_acquisition?(acquisition_confirmation_params)
      acquisition_confirmation_params.fetch(:cooperate_companies, []).blank?
    end
  end
end
