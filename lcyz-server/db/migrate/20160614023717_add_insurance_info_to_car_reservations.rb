class AddInsuranceInfoToCarReservations < ActiveRecord::Migration
  def change
    add_column :car_reservations, :proxy_insurance, :boolean, comment: "代办保险"
    add_column :car_reservations, :insurance_company_id, :integer, index: true, comment: "保险公司"
    add_column :car_reservations, :commercial_insurance_fee_cents, :integer, comment: "商业险"
    add_column :car_reservations, :compulsory_insurance_fee_cents, :integer, comment: "交强险"
  end
end
