# == Schema Information
#
# Table name: authority_roles # 权限名称
#
#  id          :integer          not null, primary key    # 权限名称
#  company_id  :integer
#  name        :string                                    # 名称
#  authorities :text             default([]), is an Array # 权限
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  note        :text                                      # 备注
#

module AuthorityRoleSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :note, :created_at, :authorities
  end
end
