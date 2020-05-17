class CreateAliances < ActiveRecord::Migration
  def change
    create_table :aliances do |t|

      t.string :name, comment: "联盟名称"
      t.integer :owner_id, comment: "所属公司ID"
      t.datetime :deleted_at, comment: "伪删除时间"

      t.timestamps null: false
    end
  end
end
