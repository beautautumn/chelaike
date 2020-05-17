class CreateMaintenanceLimits < ActiveRecord::Migration
  def change
    create_table :maintenance_limits, comment: "已经删除" do |t|
      t.integer :company_id
      t.integer :quantity, default: 0
    end
  end
end
