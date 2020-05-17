class RemoveUnusedColumnsFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :app_id
    remove_column :orders, :subject
    remove_column :orders, :body
    change_column :orders, :status, :string
    change_column :orders, :action, :string
  end
end
