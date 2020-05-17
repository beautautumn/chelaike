class AddMeterErrorToOldDriverRecordHubs < ActiveRecord::Migration
  def change
    add_column :old_driver_record_hubs, :meter_error, :boolean, comment: "里程表是否异常"
    add_column :old_driver_record_hubs, :smoke_level, :string, comment: "排放标准"
    add_column :old_driver_record_hubs, :year, :string, comment: "生产年份"
    add_column :old_driver_record_hubs, :nature, :string, comment: "车辆性质"
  end
end
