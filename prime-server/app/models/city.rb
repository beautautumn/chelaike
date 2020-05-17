# coding: utf-8
# == Schema Information
#
# Table name: cities
#
#  id          :integer          not null, primary key
#  name        :string
#  province_id :integer
#  level       :integer
#  zip_code    :string
#  pinyin      :string
#  pinyin_abbr :string
#  created_at  :datetime
#  updated_at  :datetime
#

class City < ActiveRecord::Base
  belongs_to :province
  has_many :districts, dependent: :destroy

  scope :order_by_pinyin, -> { order(:pinyin) }

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/, "")
  end

  def brothers
    @brothers ||= City.where("province_id = #{province_id}")
  end
end
