class AddActionTypeToChaDoctorRecord < ActiveRecord::Migration
  def change
    add_column :cha_doctor_records, :action_type, :string, default: "new", comment: "记录的查询类型"
  end
end
