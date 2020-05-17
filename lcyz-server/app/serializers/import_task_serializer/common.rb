# == Schema Information
#
# Table name: import_tasks # 意向导入记录
#
#  id               :integer          not null, primary key # 意向导入记录
#  user_id          :integer                                # 操作人
#  state            :string           default("pending")    # 状态
#  import_task_type :string                                 # 记录类型
#  info             :jsonb                                  # 相关信息
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer                                # 公司ID
#

module ImportTaskSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :state, :created_at, :import_task_type, :info

    belongs_to :user, serializer: UserSerializer::Mini
  end
end
