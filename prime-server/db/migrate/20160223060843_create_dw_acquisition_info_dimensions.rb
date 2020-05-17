class CreateDwAcquisitionInfoDimensions < ActiveRecord::Migration
  def change
    create_table :dw_acquisition_info_dimensions, comment: "入库信息维度" do |t|
      t.integer :acquisition_price_cents, comment: "收购价"
      t.integer :acquirer_id, comment: "收购员ID"
      t.datetime :acquired_at, comment: "收购时间"
      t.integer :acquired_at_year, comment: "收购日期所在年份"
      t.integer :acquired_at_month, comment: "收购日期所在月份"

      t.timestamps null: false
    end
  end
end
