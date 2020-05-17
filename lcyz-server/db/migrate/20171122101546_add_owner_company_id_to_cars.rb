class AddOwnerCompanyIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :owner_company_id, :integer, comment: "归属车商公司ID"
  end
end
