class AddFacadeToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :facade, :string, default: "", comment: "公司的门头照片"
  end
end
