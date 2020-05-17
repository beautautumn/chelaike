class AddAccreditedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :accredited, :boolean, default: false, commnet: "车商是否已授信"
  end
end
