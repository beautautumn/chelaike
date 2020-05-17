module CheRongYi
  class Image < Base
    attribute :id, Integer
    attribute :url, String
    attribute :name, String
    attribute :location, String
    attribute :isCover, Boolean
  end
end
