class DeleteAvatarForCompany < ActiveRecord::Migration
  def change
    remove_column :companies, :avatar
  end
end
