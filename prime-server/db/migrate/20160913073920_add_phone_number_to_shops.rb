class AddPhoneNumberToShops < ActiveRecord::Migration
  def change
    add_column :shops, :phone, :string, comment: "联系电话"
  end
end
