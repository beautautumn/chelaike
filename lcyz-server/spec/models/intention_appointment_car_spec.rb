# == Schema Information
#
# Table name: intention_appointment_cars # 预约看车
#
#  id               :integer          not null, primary key # 预约看车
#  appointment_time :datetime                               # 预约时间
#  company_id       :integer                                # 归属车商
#  car_id           :integer                                # 预约车辆
#  intention_id     :integer                                # 关系的意向
#  description      :text                                   # 预约说明
#  note             :text                                   # 备注
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require "rails_helper"

RSpec.describe IntentionAppointmentCar, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
