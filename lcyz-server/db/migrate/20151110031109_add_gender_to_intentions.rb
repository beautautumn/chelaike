class AddGenderToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :gender, :string, comment: "性别"
  end
end
