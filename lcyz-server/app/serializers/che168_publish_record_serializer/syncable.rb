# == Schema Information
#
# Table name: che168_publish_records # che168发布记录
#
#  id              :integer          not null, primary key # che168发布记录
#  company_id      :integer                                # 公司ID
#  car_id          :integer                                # 发布车辆ID
#  user_id         :integer                                # 发布者ID
#  che168_id       :integer                                # che168对应车辆ID
#  state           :string           default("pending")    # 发布状态
#  error_message   :string                                 # 错误信息
#  command         :text                                   # 发布命令记录
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  publish_state   :string           default("pending")    # che168车辆状态
#  publish_message :string                                 # che168车辆状态信息
#  syncable        :boolean          default(FALSE)        # 是否同步
#  seller_id       :string           default("")           # 销售员ID
#

module Che168PublishRecordSerializer
  class Syncable < ActiveModel::Serializer
    attributes :id, :syncable, :seller_id, :state, :error_message, :publish_state, :publish_message
  end
end
