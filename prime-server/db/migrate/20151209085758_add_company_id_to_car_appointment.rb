class AddCompanyIdToCarAppointment < ActiveRecord::Migration
  def change
    add_column :car_appointments, :company_id, :integer, index: true, comment: "公司ID"
  end
end
