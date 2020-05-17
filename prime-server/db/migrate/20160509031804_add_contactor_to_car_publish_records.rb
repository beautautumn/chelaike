class AddContactorToCarPublishRecords < ActiveRecord::Migration
  def change
    add_column :car_publish_records, :contactor, :string, comment: "各平台的联系人"
  end
end
