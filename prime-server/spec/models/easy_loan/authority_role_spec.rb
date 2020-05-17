# == Schema Information
#
# Table name: easy_loan_authority_roles # 车融易角色权限
#
#  id                      :integer          not null, primary key    # 车融易角色权限
#  name                    :string                                    # 权限名称
#  note                    :text                                      # 权限说明
#  authorities             :text             default([]), is an Array # 权限清单
#  easy_loan_sp_company_id :integer                                   # 和sp公司关联
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require "rails_helper"

RSpec.describe EasyLoan::AuthorityRole, type: :model do
end
