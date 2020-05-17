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

require "rails_helper"

RSpec.describe RecommendedCar, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
