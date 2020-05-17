module PublishCar
  class PlatformMatcher
    attr_accessor :platform

    def initialize(platform)
      @platform = platform
    end

    def construct_car_params(car)
      car_original_params = car.attributes

      car_original_params.merge(car_images_url(car))
                         .merge(price_params(car))
                         .merge(acquisition_transfer_params(car))
                         .with_indifferent_access
    end

    private

    def acquisition_transfer_params(car)
      acquition = car.acquisition_transfer
      attrs = [:annual_inspection_end_at,
               :compulsory_insurance_end_at,
               :transfer_count
      ]

      return {} if acquition.blank?

      attrs.each_with_object({}) do |attribute, acquish_hash|
        acquish_hash[attribute.to_s] = acquition.public_send(attribute)
        acquish_hash
      end
    end

    def price_params(car)
      attrs = [:acquisition_price_wan, :show_price_wan, :online_price_wan,
               :sales_minimun_price_wan, :manager_price_wan,
               :alliance_minimun_price_wan, :new_car_guide_price_wan,
               :new_car_additional_price_wan, :new_car_final_price_wan,
               :consignor_price_wan, :closing_cost_wan]

      attrs.each_with_object({}) do |attribute, price_hash|
        price_hash[attribute.to_s] = car.public_send(attribute)
        price_hash
      end
    end

    def car_images_url(car)
      acquisition_transfer = car.acquisition_transfer

      driver_image_url = if acquisition_transfer.blank?
                           ""
                         else
                           acquisition_transfer.images
                                               .where(location: %w( 行驶证 driving_license ))
                                               .map(&:url).first
                         end

      image_urls = case @platform.to_s
                   when "yiche", "che168"
                     car.images.map(&:url)
                   when "com58"
                     car.images.map { |image| { url: image.url, location: image.location } }
                   end

      { image_urls: image_urls, driver_image_url: driver_image_url }.stringify_keys
    end
  end
end
