# == Schema Information
#
# Table name: operation_records # 操作历史
#
#  id                    :integer          not null, primary key # 操作历史
#  targetable_id         :integer                                # 多态ID
#  targetable_type       :string                                 # 多态类型
#  operation_record_type :string                                 # 事件类型
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer                                # 操作人ID
#  messages              :jsonb                                  # 操作信息
#  company_id            :integer                                # 公司ID
#  shop_id               :integer                                # 店ID
#  detail                :jsonb                                  # 详情
#

module OperationRecordSerializer
  class Simple < ActiveModel::Serializer
    attributes :id, :operation_record_type, :created_at
  end
end
