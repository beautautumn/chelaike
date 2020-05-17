class CreateEasyLoanLoanBills < ActiveRecord::Migration
  def change
    create_table :easy_loan_loan_bills, comment: "借款单" do |t|
      t.integer :company_id, index: true, foreign_key: true, comment: "借款公司"
      t.integer :car_id, index: true, foreign_key: true, comment: "用哪辆车进行借款"
      t.integer :sp_company_id, comment: "通过哪家sp公司"
      t.integer :funder_company_id, comment: "提供资金公司"
      t.jsonb :car_basic_info, comment: "冗余车辆基本信息"
      t.string :state, comment: "借款单当前状态"
      t.jsonb :state_history, comment: "状态变更历史记录概要"
      t.string :apply_code, comment: "申请编号"

      t.timestamps null: false
    end
  end
end
