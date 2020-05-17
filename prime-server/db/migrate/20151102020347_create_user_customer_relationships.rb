class CreateUserCustomerRelationships < ActiveRecord::Migration
  def change
    create_table :user_customer_relationships, comment: "员工-客户关联表" do |t|
      t.belongs_to :user, index: true, comment: "员工ID"
      t.integer :customer_id, index: true, comment: "客户ID"
      t.datetime :deleted_at, comment: "删除时间"

      t.timestamps null: false
    end
  end
end
