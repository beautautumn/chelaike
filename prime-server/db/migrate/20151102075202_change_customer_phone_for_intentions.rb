class ChangeCustomerPhoneForIntentions < ActiveRecord::Migration
  def change
    remove_column :intentions, :customer_phone
    add_column :intentions, :customer_phones, :string, array: true, default: [], comment: "客户联系方式"
  end
end
