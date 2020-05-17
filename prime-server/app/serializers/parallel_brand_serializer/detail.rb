module ParallelBrandSerializer
  class Detail < ActiveModel::Serializer
    attributes :id, :first_letter, :name, :logo_url, :order, :brand_type
    has_many :styles, serializer: ParallelStyleSerializer::Common
  end
end
