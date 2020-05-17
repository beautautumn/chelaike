# frozen_string_literal: true
# == Schema Information
#
# Table name: favorite_cars # 收藏车辆
#
#  id             :integer          not null, primary key
#  wechat_user_id :integer
#  car_id         :integer                                # 车辆 ID
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tenant_id      :integer                                # 所属平台租户
#

# 目前是根据用户 union_id, 以后需要改成用户-公司/租户，
# 对于 A 公司中显示了 B 公司车辆的收藏，还需要考虑下
class FavoriteCar < ApplicationRecord
  belongs_to :wechat_user
end
