class CreateExpirationSettings < ActiveRecord::Migration
  def change
    create_table :expiration_settings, comment: "公司设置到期提醒时间" do |t|
      t.references :company, index: true, foreign_key: true, comment: "所属公司"
      t.string :notify_type, comment: "提醒类型"
      t.integer :first_notify, comment: "首次提醒时间"
      t.integer :second_notify, comment: "再次提醒时间"
      t.integer :third_notify, comment: "三次提醒时间"

      t.timestamps null: false
    end
  end
end
