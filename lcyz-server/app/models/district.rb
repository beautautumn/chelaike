# coding: utf-8
# == Schema Information
#
# Table name: districts
#
#  id          :integer          not null, primary key
#  name        :string
#  city_id     :integer
#  pinyin      :string
#  pinyin_abbr :string
#  created_at  :datetime
#  updated_at  :datetime
#

class District < ActiveRecord::Base
  belongs_to :city
  has_one :province, through: :city

  scope :order_by_pinyin, -> { order(:pinyin) }

  def short_name
    @short_name ||= name.gsub(/区|县|市|自治县/, "")
  end

  def brothers
    @brothers ||= District.where("city_id = #{city_id}")
  end
end
