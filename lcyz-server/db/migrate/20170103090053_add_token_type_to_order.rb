class AddTokenTypeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :token_type, :string, comment: "标记个人或公司的车币"
  end
end
