# == Schema Information
#
# Table name: easy_loan_cities # 车融易地区
#
#  id         :integer          not null, primary key # 车融易地区
#  name       :string                                 # 地区中文名称
#  pinyin     :string                                 # 地区拼音
#  zip_code   :string                                 # 地区邮编
#  score      :json             default({})           # 城市综合指数最小／最大／最可能分
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe EasyLoan::City, type: :model do
end
