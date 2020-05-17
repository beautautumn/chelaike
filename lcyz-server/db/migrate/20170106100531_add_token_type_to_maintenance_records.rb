class AddTokenTypeToMaintenanceRecords < ActiveRecord::Migration
  def change
    add_column :maintenance_records, :token_type, :string, comment: "支付token的类型"
    add_column :maintenance_records, :token_id, :integer, comment: "支付token"
    add_column :ant_queen_records, :token_type, :string, comment: "支付token的类型"
    add_column :ant_queen_records, :token_id, :integer, comment: "支付token"
  end
end
