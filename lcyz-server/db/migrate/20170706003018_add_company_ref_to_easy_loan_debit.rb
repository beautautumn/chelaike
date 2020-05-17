class AddCompanyRefToEasyLoanDebit < ActiveRecord::Migration
  def change
    add_reference :easy_loan_debits, :company, index: true, foreign_key: true, comment: "统计数据和公司关联"
  end
end
