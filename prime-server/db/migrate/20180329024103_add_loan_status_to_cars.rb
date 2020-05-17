class AddLoanStatusToCars < ActiveRecord::Migration
  def change
    add_column :cars, :loan_status, :string, comment: "借款状态，借款 loan，未借款 noloan"
  end
end
