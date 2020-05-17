# == Schema Information
#
# Table name: car_state_histories # 车辆状态修改历史
#
#  id                     :integer          not null, primary key # 车辆状态修改历史
#  car_id                 :integer                                # 车辆ID
#  previous_state         :string                                 # 上一个状态
#  state                  :string                                 # 当前状况
#  sellable               :boolean                                # 是否可售
#  occurred_at            :datetime                               # 修改时间
#  note                   :text                                   # 描述
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  predicted_restocked_at :datetime                               # 预计回厅时间
#

module CarStateHistorySerializer
  class Common < ActiveModel::Serializer
    attributes :car_id, :previous_state, :state, :sellable, :occurred_at, :note,
               :predicted_restocked_at, :created_at
  end
end
