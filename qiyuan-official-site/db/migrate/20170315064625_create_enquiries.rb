class CreateEnquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :enquiries, comment: "询价记录" do |t|
      t.integer :car_id, comment: "询价车辆"
      t.string :name, comment: "姓名"
      t.string :phone, comment: "联系电话"
      t.integer :wechat_user_id, index: true

      t.timestamps
    end
  end
end
