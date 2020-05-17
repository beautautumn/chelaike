require "rails_helper"

RSpec.describe LoanMessageWorker do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:wangwu) { users(:wangwu) }
  let(:loan_bill) { easy_loan_loan_bills(:tianche_bill_a) }

  describe "#send_rong_push" do
    before do
      lisi.update!(company_id: tianche.id)
      zhangsan.update!(company_id: tianche.id)

      give_authority(zhangsan, "融资管理")

      @record = OperationRecord.create!(
        targetable: loan_bill,
        company_id: tianche.id,
        operation_record_type: :accredited_updated,
        user_id: lisi.id,
        messages: { car_id: 1 }
      )
    end

    it "发送给有融资管理权限的人" do
      worker = LoanMessageWorker.new
      user_ids = worker.send(:push_tag, @record)
      expect(user_ids).to match_array [zhangsan.id]
    end
  end
end
