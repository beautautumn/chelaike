module ParallelBrandSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :first_letter, :name, :logo_url, :order, :brand_type
  end
end
