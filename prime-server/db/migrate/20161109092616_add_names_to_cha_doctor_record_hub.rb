class AddNamesToChaDoctorRecordHub < ActiveRecord::Migration
  def change
    add_column :cha_doctor_record_hubs, :series_name, :string, comment: "车系名"
    add_column :cha_doctor_record_hubs, :style_name, :string, comment: "车型"
  end
end
