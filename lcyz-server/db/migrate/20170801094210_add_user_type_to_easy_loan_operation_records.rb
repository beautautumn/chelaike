class AddUserTypeToEasyLoanOperationRecords < ActiveRecord::Migration
  def change
    add_column :easy_loan_operation_records, :user_type, :string, comment: "操作人多态"
    add_column :easy_loan_operation_records, :detail, :jsonb, comment: "操作记录详情"
  end
end
