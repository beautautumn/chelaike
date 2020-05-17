class AddCustomerPhoneToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :customer_phone, :string, comment: "客户电话"
  end
end
