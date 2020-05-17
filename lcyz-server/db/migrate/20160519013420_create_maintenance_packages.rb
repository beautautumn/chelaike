class CreateMaintenancePackages < ActiveRecord::Migration
  def change
    create_table :maintenance_packages, comment: "已经删除" do |t|
      t.string :name
      t.string :title
      t.string :description
      t.integer :price_cents, limit: 8
      t.integer :quantity, limit: 8, comment: '包含数量'

      t.timestamps null: false
    end
  end
end
