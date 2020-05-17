# frozen_string_literal: true
# == Schema Information
#
# Table name: transfer_histories
#
#  id            :integer          not null, primary key
#  car_id        :integer                                # 车辆id
#  transfer_at   :datetime                               # 过户时间
#  home_location :string                                 # 归属地
#  transfer_type :string                                 # 过户类型 person business
#  description   :string                                 # 过户描述
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TransferHistory < ApplicationRecord
end
