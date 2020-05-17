class CreateAcquisitionConfirmations < ActiveRecord::Migration
  def change
    create_table :acquisition_confirmations, comment: "确认收车清单" do |t|
      t.integer :acquisition_price_cents, comment: "收购成交价"
      t.date :acquired_at, comment: "收购日期"
      t.integer :key_count, comment: "钥匙数量"
      t.references :company, index: true, foreign_key: true, comment: "入库商家"
      t.references :shop, index: true, foreign_key: true, comment: "入库所属分店"
      t.references :acquisition_car_info, index: true, foreign_key: true, comment: "对应的收车信息"
      t.references :alliance, comment: "所属联盟"
      t.integer :cooperate_companies, array: true, default: [], comment: "合作收购商家"

      t.timestamps null: false
    end
  end
end
