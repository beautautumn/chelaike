module ImageSerializer
  module Concern
    def image_attributes(image, url)
      {
        id: image.id,
        url: url,
        name: image.name,
        location: image.location,
        is_cover: image.is_cover
      }
    end
  end
end
