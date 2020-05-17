class DropUserCustomerRelationship < ActiveRecord::Migration
  def change
    drop_table :user_customer_relationships
  end
end
