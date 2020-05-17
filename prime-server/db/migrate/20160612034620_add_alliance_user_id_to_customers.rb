class AddAllianceUserIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :alliance_user_id, :integer, comment: "联盟公司员工ID"
    add_column :customers, :alliance_company_id, :integer, comment: "联盟公司ID"
    add_index :customers, :alliance_user_id
    add_index :customers, :alliance_company_id
  end
end
