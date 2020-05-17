# == Schema Information
#
# Table name: easy_loan_messages # 车融易里的消息
#
#  id                            :integer          not null, primary key # 车融易里的消息
#  user_id                       :integer                                # 对应user
#  user_type                     :string                                 # user多态
#  easy_loan_operation_record_id :integer                                # 对应的车融易里操作记录
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

require "rails_helper"

RSpec.describe EasyLoan::Message, type: :model do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:lisi) { easy_loan_users(:easy_loan_user_b) }
  let(:tianche) { companies(:tianche) }
  let(:loan_bill) { easy_loan_loan_bills(:tianche_bill_a) }

  describe ".create_messages" do
    before do
      @operation_record = loan_bill.easy_loan_operation_records.create!(
        operation_record_type: :loan_bill_state_updated,
        user: zhangsan
      )
    end

    it "根据操作记录去创建相应的消息记录" do
      user_ids = [zhangsan.id, lisi.id]
      EasyLoan::Message.create_messages(@operation_record, user_ids)
      expect(EasyLoan::Message.count).to eq 2
    end
  end
end
