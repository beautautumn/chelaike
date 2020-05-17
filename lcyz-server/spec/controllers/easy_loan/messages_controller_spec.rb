require "rails_helper"

RSpec.describe EasyLoan::MessagesController, type: :controller do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:lisi) { easy_loan_users(:easy_loan_user_b) }
  let(:prime_zhangsan) { users(:zhangsan) }

  let(:tianche) { companies(:tianche) }
  let(:loan_bill) { easy_loan_loan_bills(:tianche_bill_a) }
  let(:tianche_sp) { easy_loan_sp_companies(:tianche_sp) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:operation_record) { easy_loan_operation_records(:zhangsan_update_tianche_bill_a) }

  before do
    login_user(zhangsan)
    EasyLoan::Message.create_messages(operation_record, [zhangsan.id, lisi.id])
  end

  describe "GET index" do
    it "得到这个用户的所有消息" do
      loan_auth_get :index
      expect(response_json[:data]).to be_present
    end
  end
end
