class AddClientInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :client_info, :jsonb, comment: "客户端信息"
  end
end
