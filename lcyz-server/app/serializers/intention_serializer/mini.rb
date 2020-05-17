module IntentionSerializer
  class Mini < ActiveModel::Serializer
    attributes :id, :customer_id, :customer_name, :intention_type, :creator_id,
               :assignee_id, :province, :city, :intention_level_id, :channel_id,
               :created_at, :updated_at, :company_id, :shop_id, :customer_phones,
               :state, :customer_phone, :intention_note, :gender, :seeking_cars,
               :brand_name, :series_name, :style_name, :minimum_price_wan, :maximum_price_wan,
               :color, :mileage, :licensed_at, :interviewed_time, :processing_time,
               :estimated_price_wan, :checked_count, :consigned_at,
               :deposit_wan, :closing_cost_wan, :closing_car_name, :earnest

    belongs_to :assignee, serializer: UserSerializer::Mini
    belongs_to :intention_level, serializer: IntentionLevelSerializer::Common
  end
end
