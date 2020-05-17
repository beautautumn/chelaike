class AddTokenTypeAndIdToDashenglaileRecords < ActiveRecord::Migration
  def change
    add_column :dashenglaile_records, :token_type, :string, comment: "支付token的类型"
    add_column :dashenglaile_records, :token_id, :integer, comment: "支付token"
  end
end
