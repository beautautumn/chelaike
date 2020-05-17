class AddChaDoctorUnitPriceToMaintenanceSettings < ActiveRecord::Migration
  def change
    add_column :maintenance_settings, :cha_doctor_unit_price, :decimal, precision: 8, scale: 2, default: 12
  end
end
