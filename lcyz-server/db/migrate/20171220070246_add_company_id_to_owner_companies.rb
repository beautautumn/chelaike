class AddCompanyIdToOwnerCompanies < ActiveRecord::Migration
  def change
    add_column :owner_companies, :company_id, :integer, comment: "所属车商"

    OwnerCompany.all.each do |c|
      c.update_columns(company_id: c.shop.company_id)
    end
  end
end
