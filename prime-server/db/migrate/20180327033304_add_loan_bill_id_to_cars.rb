class AddLoanBillIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :loan_bill_id, :integer, comment: "车辆所属的借款单ID"
  end
end
