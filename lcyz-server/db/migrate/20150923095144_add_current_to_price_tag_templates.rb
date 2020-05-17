class AddCurrentToPriceTagTemplates < ActiveRecord::Migration
  def change
    add_column :price_tag_templates, :current, :boolean, default: true, index: true, comment: "是否当前模板"
  end
end
