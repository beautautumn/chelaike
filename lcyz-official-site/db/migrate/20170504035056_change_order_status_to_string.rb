class ChangeOrderStatusToString < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :status, :string
  end
end
