class AddRealInventoryAmountToEasyLoanDebit < ActiveRecord::Migration
  def change
    add_column :easy_loan_debits, :real_inventory_amount, :integer, comment: "真实库存资金量数据"
  end
end
