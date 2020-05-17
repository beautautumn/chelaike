class CreateIntentions < ActiveRecord::Migration
  def change
    create_table :intentions, comment: "意向" do |t|
      t.integer :customer_id, index: true, comment: "客户ID"
      t.string :customer_phone, array: true, default: [], comment: "客户联系电话"
      t.string :customer_name, comment: "客户姓名"
      t.string :intention_type, index: true, comment: "意向类型"
      t.jsonb :intention_note, default: {}, comment: "意向描述"
      t.integer :creator_id, index: true, comment: "意向创建者"
      t.integer :assignee_id, index: true, comment: "分配员工ID"
      t.string :province, comment: "省份"
      t.string :city, comment: "城市"
      t.integer :intention_level_id, index: true, comment: "意向级别ID"
      t.belongs_to :channel, index: true, comment: "客户渠道"

      t.timestamps null: false
    end
  end
end
