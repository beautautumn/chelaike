class AddSourceToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :source, :string, default: "user_operation", comment: "客户产生来源"
  end
end
