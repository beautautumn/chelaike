class AddConfigurationExtraNoteToCar < ActiveRecord::Migration
  def change
    add_column :cars, :configuration_extra_note, :text, comment: "通过快捷选择生成的配置"
  end
end
