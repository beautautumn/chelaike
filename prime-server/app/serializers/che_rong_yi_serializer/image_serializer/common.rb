module CheRongYiSerializer
  module ImageSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :url, :name, :location, :isCover
    end
  end
end
