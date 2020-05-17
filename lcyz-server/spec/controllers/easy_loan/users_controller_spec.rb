# == Schema Information
#
# Table name: easy_loan_users # 车融易用户模型
#
#  id                          :integer          not null, primary key    # 车融易用户模型
#  phone                       :string                                    # 手机号码
#  token                       :string                                    # 验证码
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  expired_at                  :datetime                                  # 短信验证码失效时间
#  current_device_number       :string                                    # 车融易当前登录设备号码
#  name                        :string                                    # 车融易用户姓名
#  easy_loan_sp_company_id     :integer                                   # 所属sp公司
#  authorities                 :text             default([]), is an Array # 权限清单
#  city                        :text                                      # 员工所属地区
#  status                      :boolean          default(TRUE)            # 员工状态
#  easy_loan_authority_role_id :integer                                   # 角色关联
#  rc_token                    :string                                    # 融云token
#

require "rails_helper"

RSpec.describe EasyLoan::UsersController, type: :controller do
  fixtures :all
  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:easy_user_new) { easy_loan_users(:easy_loan_user_c) }
  let(:fengkongrenyuan) { easy_loan_authority_roles(:fengkongrenyuan) }

  before do
    login_user(zhangsan)
  end

  describe  "GET me" do
    it "get current user profile" do
      loan_auth_get :me
      expect(response_json[:data][:id]).to eq zhangsan.id
    end
  end

  describe "GET index" do
    it "get all tianche_sp easy_laon users" do
      loan_auth_get :index
      expect(response_json[:data].count).to eq(2)
    end

    it "easy_laon users with own authority_role" do
      zhangsan.authority_role = fengkongrenyuan
      zhangsan.save
      loan_auth_get :index
      expect(response_json[:data].second[:authority_role][:name]).to eq "风控专员"
    end
  end

  describe "POST create" do
    it "create an easy_loan user" do
      new_record = lambda do
        loan_auth_post :create, user: {
          phone: "13800138004",
          name: "张三",
          city: "深圳",
          authorities: easy_user_new.authorities }
      end
      expect { new_record.call }.to change {
        EasyLoan::User.sp_company_users(@current_user.easy_loan_sp_company_id).to_a.count
      }.by(1)
    end

    it "create an easy_loan user with authority_role association" do
      loan_auth_post :create, user: {
        phone: "13800138010",
        name: "张三",
        city: "深圳",
        easy_loan_authority_role_id: fengkongrenyuan.id
      }
      expect(EasyLoan::User.where(phone: "13800138010").first.authorities).to eq(fengkongrenyuan.authorities)
    end
  end

  describe "PUT update" do
    before do
      allow_any_instance_of(EasyLoan::User).to receive(:refresh_rongcloud).and_return(false)
    end
    it "update specify easy_loan_user" do
      loan_auth_put :update, id: easy_user_new.id,
                             user: {
                               phone: easy_user_new.phone,
                               name: "李四",
                               city: "深圳",
                               authorities: %w(查看申请单 车看车商 修改贷款状态 受改授信额度)
                             }
      expect(response_json[:data][:authorities]).to eq %w(查看申请单 车看车商 修改贷款状态 受改授信额度)
    end

    it "update user status" do
      loan_auth_put :update, id: zhangsan.id,
                      user: {
                        status: false
                      }
      expect(zhangsan.reload.status).to eq false
    end

    it "update easy_loan user authority_role" do
      loan_auth_put :update, id: zhangsan.id,
                      user: {
                        easy_loan_authority_role_id: fengkongrenyuan.id
                      }
      expect(response_json[:data][:authorities]).to eq %w(查看申请单 车看车商 修改贷款状态 受改授信额度)
    end
  end

  describe "POST rc_token" do
    it "得到用户的融云token" do
      VCR.use_cassette("rongcloud/easy_loan_user") do
        loan_auth_post :rc_token
        expect(response_json[:data][:rc_token]).to be_present
      end
    end
  end
end
