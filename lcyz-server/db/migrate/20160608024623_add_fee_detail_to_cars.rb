class AddFeeDetailToCars < ActiveRecord::Migration
  def change
    add_column :cars, :fee_detail, :text, comment: "费用情况"
  end
end
