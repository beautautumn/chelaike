class ChangeClainmsToClaims < ActiveRecord::Migration
  def change
    rename_column :old_driver_record_hubs, :clainms, :claims
    rename_column :old_driver_record_hubs, :licence_no, :license_no
  end
end
