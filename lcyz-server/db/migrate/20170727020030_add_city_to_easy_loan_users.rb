class AddCityToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column :easy_loan_users, :city, :text, comment: "员工所属地区"
  end
end
