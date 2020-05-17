class AddCooperateUsersToAcquisitionConfirmation < ActiveRecord::Migration
  def change
    add_column :acquisition_confirmations, :cooperate_users, :integer, array: true, default: [], comment: "合作人"
  end
end
