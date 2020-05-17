# frozen_string_literal: true
# == Schema Information
#
# Table name: enquiries # 询价记录
#
#  id             :integer          not null, primary key
#  car_id         :integer                                # 询价车辆
#  name           :string                                 # 姓名
#  phone          :string                                 # 联系电话
#  wechat_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tenant_id      :integer                                # 所属平台租户
#

require "rails_helper"

RSpec.describe Enquiry, type: :model do
end
