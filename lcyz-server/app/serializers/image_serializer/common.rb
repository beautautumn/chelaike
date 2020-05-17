# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  imageable_id   :integer                                # 多态ID
#  imageable_type :string                                 # 多态名
#  url            :string                                 # 图片URL
#  name           :string                                 # 名称
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  location       :string                                 # 图片位置
#  is_cover       :boolean          default(FALSE)        # 是否为LOGO
#

module ImageSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :url, :name, :location, :is_cover

    def location
      location_text = object.location
      {
        "行驶证" => "driving_license",
        "登记证" => "registration_license",
        "保单" => "insurance"
      }.fetch(location_text, location_text)
    end
  end
end
