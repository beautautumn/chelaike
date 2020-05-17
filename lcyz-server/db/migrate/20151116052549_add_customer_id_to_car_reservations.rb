class AddCustomerIdToCarReservations < ActiveRecord::Migration
  def change
    add_column :car_reservations, :customer_id, :integer, comment: "客户ID"
  end
end
