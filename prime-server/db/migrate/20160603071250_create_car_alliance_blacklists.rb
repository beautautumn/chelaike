class CreateCarAllianceBlacklists < ActiveRecord::Migration
  def change
    create_table :car_alliance_blacklists, comment: "不允许车辆在某个平台展示" do |t|
      t.references :car, index: true, foreign_key: true
      t.references :alliance, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
