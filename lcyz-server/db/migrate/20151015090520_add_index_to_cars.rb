class AddIndexToCars < ActiveRecord::Migration
  def change
    add_index :cars, :company_id
  end
end
