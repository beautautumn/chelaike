class AddCompanyIdToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :company_id, :integer, index: true, comment: "公司ID"
    add_column :intentions, :shop_id, :integer, index: true, comment: "店ID"
  end
end
