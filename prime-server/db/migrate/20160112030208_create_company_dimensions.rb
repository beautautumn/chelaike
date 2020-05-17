class CreateCompanyDimensions < ActiveRecord::Migration
  def change
    create_table :company_dimensions, comment: "公司维度" do |t|

      t.integer :company_id, comment: "公司ID"
      t.integer :shop_id, comment: "分店ID"

      t.timestamps null: false
    end
  end
end
