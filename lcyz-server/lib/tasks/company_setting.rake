namespace :company_setting do
  desc "update all company's industry_rating and assets_debts_rating columns to default value"
  task rating: :environment do
    Company.update_all("industry_rating = '3.0', assets_debts_rating = '0.4'")
  end
end
