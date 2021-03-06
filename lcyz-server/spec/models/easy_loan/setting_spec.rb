# == Schema Information
#
# Table name: easy_loan_settings # 车融易全局数据设置
#
#  id                :integer          not null, primary key # 车融易全局数据设置
#  phone             :string                                 # 联系电话
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  gross_rake        :decimal(, )      default(0.7)          # （健康评级）毛利润率评级权重
#  assets_debts_rate :decimal(, )      default(0.3)          # （健康评级）资产负债率评级权重
#  inventory_amount  :decimal(, )      default(0.2)          # （综合指数）库存资金量权重
#  operating_health  :decimal(, )      default(0.4)          # （综合指数）经营健康评级权重
#  industry_rating   :decimal(, )      default(0.4)          # （综合指数）行业风评权重
#

require "rails_helper"

RSpec.describe EasyLoan::Setting, type: :model do
end
