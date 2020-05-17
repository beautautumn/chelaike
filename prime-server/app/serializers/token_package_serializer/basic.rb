module TokenPackageSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :name, :title, :description, :price_yuan
  end
end
