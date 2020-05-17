# frozen_string_literal: true
# == Schema Information
#
# Table name: recommended_cars # 首页推荐车辆
#
#  id             :integer          not null, primary key
#  car_id         :integer                                # 车辆id
#  order          :integer                                # 排序
#  tenant_id      :integer                                # 所归属租户
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shown_pic_url  :string
#  shown_car_name :string
#

class RecommendedCar < ApplicationRecord
  belongs_to :tenant

  attr_accessor :car
end
