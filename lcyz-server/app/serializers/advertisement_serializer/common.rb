module AdvertisementSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :title, :image_url, :redirect_url, :show_seconds
  end
end
