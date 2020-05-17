require "rails_helper"

RSpec.describe EasyLoan::AuthoritiesController, type: :controller do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:lisi) { easy_loan_users(:easy_loan_user_b) }

  before do
    login_user(zhangsan)
    give_authority(lisi, "角色管理", "员工管理")
  end

  describe "Get index" do
    it "get the specify easy loan user authorities" do
      loan_auth_get :index, user_id: lisi.id
      expect(response_json[:data].count).to eq 2
    end

    it "get all authorities in easy loan users system" do
      loan_auth_get :index
      expect(response_json[:data]).to eq(EasyLoan::User.authorities)
    end
  end
end
