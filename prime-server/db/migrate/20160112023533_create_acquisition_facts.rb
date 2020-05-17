class CreateAcquisitionFacts < ActiveRecord::Migration
  def change
    create_table :acquisition_facts, comment: "入库事实" do |t|

      t.integer :car_id, index: true, comment: "车辆ID"
      t.integer :acquisition_info_dimension_id, index: true, comment: "入库信息维度ID"
      t.integer :out_stock_info_dimension_id, index: true, comment: "出库信息维度ID"
      t.integer :car_dimension_id, index: true, comment: "车辆维度ID"
      t.integer :company_dimension_id, index: true, comment: "公司维度ID"

      t.timestamps null: false
    end
  end
end
