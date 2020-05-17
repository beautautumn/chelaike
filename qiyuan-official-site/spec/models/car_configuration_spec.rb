# frozen_string_literal: true
# == Schema Information
#
# Table name: car_configurations # 车辆配置
#
#  id                      :integer          not null, primary key
#  tenant_id               :integer                                # 所归属租户
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  loan_data               :jsonb            not null              # 贷款配置信息
#  maintenance_price_cents :integer          default(1500)         # 维保查询价格
#  insurance_price_cents   :integer          default(1500)         # 用户查询保险记录详情时价格
#

require "rails_helper"

RSpec.describe CarConfiguration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
