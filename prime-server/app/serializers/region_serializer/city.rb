module RegionSerializer
  class City < ActiveModel::Serializer
    attributes :id, :name, :province_id, :level, :zip_code, :pinyin, :pinyin_abbr,
               :created_at, :updated_at, :short_name
  end
end
