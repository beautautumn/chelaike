# == Schema Information
#
# Table name: provinces
#
#  id          :integer          not null, primary key
#  name        :string
#  pinyin      :string
#  pinyin_abbr :string
#  created_at  :datetime
#  updated_at  :datetime
#

class Province < ActiveRecord::Base
  has_many :cities, dependent: :destroy
  has_many :districts, through: :cities

  scope :order_by_pinyin, -> { order(:pinyin) }

  def short_name
    @short_name ||= name.gsub(/市|省|特别行政区/, "")
  end
end
