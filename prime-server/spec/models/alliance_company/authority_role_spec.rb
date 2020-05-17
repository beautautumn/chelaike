# == Schema Information
#
# Table name: alliance_authority_roles # 联盟公司的权限角色
#
#  id                  :integer          not null, primary key    # 联盟公司的权限角色
#  alliance_company_id :integer
#  name                :string                                    # 名称
#  authorities         :text             default([]), is an Array # 权限
#  note                :text                                      # 备注
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require "rails_helper"

RSpec.describe AllianceCompany::AuthorityRole, type: :model do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }

  it "belongs to alliance_company" do
    role = AllianceCompany::AuthorityRole.create(alliance_company: alliance_tianche,
                                                 authorities: %w(a b c))
    expect(role.alliance_company).to eq alliance_tianche
  end

  describe ".find_or_create_super_manager(company_id)" do
    it "创建一个联盟后台的超级管理员角色" do
      role = AllianceCompany::AuthorityRole.find_or_create_super_manager(alliance_tianche)
      expect(role.alliance_company).to eq alliance_tianche
      expect(role.name).to eq "超级管理员"
      expect(role.authorities).to include "角色管理"
    end
  end
end
