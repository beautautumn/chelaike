# == Schema Information
#
# Table name: intention_expirations # 意向过期时间
#
#  id              :integer          not null, primary key # 意向过期时间
#  company_id      :integer                                # 公司ID
#  expiration_days :integer          not null              # 过期天数
#  note            :text                                   # 备注
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module IntentionExpirationSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :recovery_time, :note, :company_id, :created_at
  end
end
