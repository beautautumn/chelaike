class RenameEasyLoanCitiesScopeColumn < ActiveRecord::Migration
  def change
    rename_column :easy_loan_cities, :scope, :score
  end
end
