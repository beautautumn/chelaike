class CreateEasyLoanLoanBillHistories < ActiveRecord::Migration
  def change
    create_table :easy_loan_loan_bill_histories, comment: "借款单状态变更历史" do |t|
      t.references :easy_loan_loan_bill, index: true, foreign_key: true, comment: "对应的借款单"
      t.references :user, index: true, foreign_key: true, comment: "操作人"
      t.string :bill_state, comment: "记录当前的状态"
      t.string :message, comment: "记录时的状态对应的消息"
      t.string :note, comment: "对应的备注"

      t.timestamps null: false
    end
  end
end
