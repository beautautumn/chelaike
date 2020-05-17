class AddBeatToEasyLoanDebit < ActiveRecord::Migration
  def change
    add_column :easy_loan_debits, :beat_global, :decimal, comment: "综合评分打败全国车商数据"
    add_column :easy_loan_debits, :beat_local, :decimal, comment: "综合评分打败本地车商数据"
  end
end
