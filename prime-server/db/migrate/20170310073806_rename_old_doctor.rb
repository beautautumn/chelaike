class RenameOldDoctor < ActiveRecord::Migration
  def change
    rename_table :old_doctor_records, :old_driver_records
  end
end
