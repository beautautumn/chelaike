class AddCarConfigurationNoteToCars < ActiveRecord::Migration
  def change
    add_column :cars, :configuration_note, :text, comment: "车型配置描述"
  end
end
