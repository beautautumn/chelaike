class ChangeIntentionLevelsCompanyTypeDefault < ActiveRecord::Migration
  def change
    change_column_default :intention_levels, :company_type, "Company"
  end
end
