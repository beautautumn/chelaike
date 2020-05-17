class AddNoteToPriceTagTemplates < ActiveRecord::Migration
  def change
    add_column :price_tag_templates, :note, :text, comment: "说明"
  end
end
