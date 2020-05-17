class CreateEasyLoanAuthorityRoles < ActiveRecord::Migration
  def change
    create_table :easy_loan_authority_roles, comment: "车融易角色权限" do |t|
      t.string :name, comment: "权限名称"
      t.text :note, comment: "权限说明"
      t.text :authorities, array: true, default: [], comment: "权限清单"
      t.references :easy_loan_sp_company, index: true, foreign_key: true, comment: "和sp公司关联"

      t.timestamps null: false
    end
  end
end
