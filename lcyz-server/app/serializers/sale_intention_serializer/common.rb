module SaleIntentionSerializer
  class Common < ActiveModel::Serializer
    attributes :brand_name, :series_name, :style_name, :mileage, :licensed_at,
               :phone, :created_at, :province, :city, :expected_price_wan,
               :expected_price_yuan
  end
end
