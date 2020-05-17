module CheRongYi
  class Car < Base
    attribute :id, Integer
    attribute :brand_name, String
    attribute :series_name, String
    attribute :style_name, String
    attribute :company_id, Integer
    attribute :shop_id, Integer
    attribute :estimate_price_cents, Integer
    attribute :licenced_at, DateTime
    attribute :show_price_cents, Integer
    attribute :mileage, Float
    attribute :exterior_color, String
    attribute :keys_count, Integer
    attribute :vin, String
    attribute :state, String
    attribute :check_report_url, String
    attribute :check_report_type, String
    attribute :chelaike_car_id, Integer

    attribute :images, Array[CheRongYi::Image]

    def name
      [brand_name, series_name, style_name].reject(&:blank?).join(" ")
    end

    def estimate_price_wan
      return unless estimate_price_cents
      estimate_price_cents.to_d / 1_000_000.0
    end

    def cover_url
      image = images.select { |i| i.isCover == true }
      image.first.try(:url)
    end

    def show_price_wan
      return unless show_price_cents
      show_price_cents / 1_000_000.0
    end
  end
end
