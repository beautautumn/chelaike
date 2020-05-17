class AddTokenTypeAndInfoToChaDoctor < ActiveRecord::Migration
  def up
    add_column :cha_doctor_records, :token_type, :string
    add_column :cha_doctor_records, :token_id, :integer
  end

  def down
    remove_column :cha_doctor_records, :token_type
    remove_column :cha_doctor_records, :token_id
  end
end
