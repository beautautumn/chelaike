class CreateAdvertisements < ActiveRecord::Migration[5.0]
  def change
    create_table :advertisements, comment: "广告" do |t|
      t.string :ad_type, comment: "广告类型"
      t.string :image_url, comment: "图片地址"
      t.string :link, comment: "广告链接地址"
      t.references :tenant, foreign_key: true, comment: "所归属租户"

      t.timestamps
    end
  end
end
