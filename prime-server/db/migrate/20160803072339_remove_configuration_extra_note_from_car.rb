class RemoveConfigurationExtraNoteFromCar < ActiveRecord::Migration
  def change
    remove_column :cars, :configuration_extra_note, :text
  end
end
