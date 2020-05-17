class AddSummanyStatusDataToChaDoctorRecordHub < ActiveRecord::Migration
  def change
    add_column :cha_doctor_record_hubs, :summany_status_data, :jsonb, comment: "概况的状态"
  end
end
