require "rails_helper"

RSpec.describe V1::TokenBillsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:user_token) { tokens(:user_token) }
  let(:company_token) { tokens(:company_token) }

  let(:maintenance_record_uncheck) { maintenance_records(:maintenance_record_uncheck) }
  let(:user_token_bill) { token_bills(:user_token_bill) }
  let(:company_token_bill) { token_bills(:company_token_bill) }

  describe "GET index" do
    before do
      TokenBill.create!(token_type: :user,
                        created_at: 1.month.ago,
                        owner_id: zhangsan.id)
      user_token_bill.update!(owner_id: zhangsan.id)
      company_token_bill.update!(owner_id: tianche.id)
      login_user(zhangsan)
    end

    it "如果传入的类型是user, 得到个人账单列表" do
      auth_get :index, token_type: :user

      expect(response_json[:data].count).to eq 2
    end

    it "如果传入的类型是company, 得到公司账单列表"
  end
end
