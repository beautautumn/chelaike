module CheRongYiSerializer
  module CarSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :brand_name, :series_name, :style_name,
                 :name, :company_id, :shop_id,
                 :estimate_price_cents, :estimate_price_wan,
                 :licenced_at, :show_price_cents, :mileage,
                 :exterior_color, :keys_count, :vin, :check_report_url,
                 :check_report_type, :chelaike_car_id, :images,
                 :cover_url, :show_price_wan

      has_many :images, serializer: CheRongYiSerializer::ImageSerializer::Common
    end
  end
end
