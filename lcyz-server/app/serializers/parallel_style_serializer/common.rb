module ParallelStyleSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :origin, :color, :configuration, :status,
               :suggested_price_wan, :sell_price_wan, :style_type

    has_many   :images, serializer: ImageSerializer::Common
    belongs_to :brand,
               serializer: ParallelBrandSerializer::Common,
               include: false
  end
end
