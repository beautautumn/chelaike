require "rails_helper"

RSpec.describe AllianceCompanyService::AuthorityRole::Create do
  fixtures :all

  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:service) do
    AllianceCompanyService::AuthorityRole::Create.new(
      alliance_tianche.id,
      alliance_zhangsan.id
    )
  end

  describe "#create" do
    context "user has authority to create roles" do
      it "creates a new role for the company" do
        alliance_zhangsan.update_columns(authorities: alliance_zhangsan.authorities + ["角色管理"])
        role = service.create(
          name: "manager", note: "管理员",
          authorities: %w(在库车辆查询 车辆信息编辑)
        )

        expect(alliance_tianche.authority_roles).to include(role)
      end
    end

    context "user has no authority" do
      it "raises error" do
        alliance_zhangsan.update_columns(authorities: alliance_zhangsan.authorities - ["角色管理"])
        expect do
          service.create(
            name: "管理员", note: "管理员",
            authorities: %w(在库车辆查询 车辆信息编辑)
          )
        end.to raise_error(AllianceCompanyService::AuthorityRole::CreateError, "没有操作权限")
      end
    end
  end

  describe "#grant_manager_authorities" do
    it "给这个用户赋上超级管理员权限" do
      service.grant_manager_authorities
      alliance_zhangsan.reload
      expect(alliance_zhangsan.authorities).to include "员工管理"
    end
  end
end
