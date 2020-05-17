class CreateCarInfoPublishRecords < ActiveRecord::Migration
  def change
    create_table :car_info_publish_records, comment: "收车信息发送记录" do |t|
      t.references :acquisition_car_info, index: true, foreign_key: true, comment: "对应的收车信息"
      t.references :chatable, index: true, polymorphic: true, comment: "发送到的群组或个人"

      t.timestamps null: false
    end
  end
end
