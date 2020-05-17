class AddVinImageToMaintenanceRecords < ActiveRecord::Migration
  def change
    add_column :maintenance_records, :vin_image, :string, comment: "vin码图片地址"
  end
end
