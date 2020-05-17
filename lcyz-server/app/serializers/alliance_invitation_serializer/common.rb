# == Schema Information
#
# Table name: alliance_invitations
#
#  id                  :integer          not null, primary key
#  alliance_id         :integer                                # 联盟ID
#  company_id          :integer                                # 公司ID
#  state               :string           default("pending")    # 联盟邀请状态
#  assignee_id         :integer                                # 处理人
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  operation_record_id :integer                                # 联盟邀请操作记录
#

module AllianceInvitationSerializer
  class Common < ActiveModel::Serializer
    attributes :assignee_id, :state, :company_id, :alliance_id, :created_at
  end
end
