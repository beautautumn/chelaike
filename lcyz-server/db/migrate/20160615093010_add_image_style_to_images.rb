class AddImageStyleToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_style, :string, comment: "图片的类型"
  end
end
