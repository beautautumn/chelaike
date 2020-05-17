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

RSpec.describe EasyLoan::AuthorityRolesController, type: :controller do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:fengkongrenyuan) { easy_loan_authority_roles(:fengkongrenyuan) }

  before do
    login_user(zhangsan)
  end

  describe "GET index" do
    it "return all authority_roles" do
      loan_auth_get :index
      expect(response_json[:data].count).to eq 2
    end
  end

  describe "POST create" do
    it "create easy_loan authority_role" do
      new_record = lambda do
        loan_auth_post :create, authority_role: {
          name: "角色名称",
          note: "新添加的角色",
          authorities: %w(最大的权限 访问资源权限)
        }
      end
      expect { new_record.call }.to change { EasyLoan::AuthorityRole.count }.by(1)
    end
  end

  describe "PUT update" do
    it "update specify easy_laon authority_role" do
      loan_auth_put :update, id: fengkongrenyuan.id,
                             authority_role: {
                               name: "专员",
                               note: "测试专用",
                               authorities: %w(查看申请单 查看看车商 修改贷款状态 受改授信额度)
                             }
      expect(response_json.fetch(:data).fetch(:authorities)).to eq %w(查看申请单 查看看车商 修改贷款状态 受改授信额度)
    end
  end
end
