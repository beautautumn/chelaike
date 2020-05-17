class ActiveTagDefaultFalseForCompaniesAndAlliances < ActiveRecord::Migration
  def change
    change_column_default :companies, :active_tag, false
    change_column_default :alliances, :active_tag, false
  end
end
