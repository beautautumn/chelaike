class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements, comment: "广告" do |t|
      t.string :title, comment: "标题"
      t.string :image_url, comment: "图片地址"
      t.string :redirect_url, comment: "跳转链接"

      t.timestamps null: false
    end
  end
end
