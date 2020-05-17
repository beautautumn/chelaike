# == Schema Information
#
# Table name: intention_levels # 意向级别
#
#  id              :integer          not null, primary key # 意向级别
#  company_id      :integer                                # 公司ID
#  name            :string                                 # 名称
#  note            :string                                 # 说明
#  deleted_at      :datetime                               # 删除时间
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  time_limitation :integer          default(0)            # 时间限制
#

module IntentionLevelSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :note, :company_id, :created_at, :time_limitation, :company_type
  end
end
