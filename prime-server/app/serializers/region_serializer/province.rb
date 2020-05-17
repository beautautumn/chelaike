module RegionSerializer
  class Province < ActiveModel::Serializer
    attributes :id, :name, :pinyin, :pinyin_abbr, :created_at, :updated_at,
               :short_name
  end
end
