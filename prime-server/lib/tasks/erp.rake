namespace :erp do
  desc "同步所有信息给erp"
  task syncs_all: :environment do
    Company.where.not(erp_url: nil).find_each(batch_size: 20) do |company|
      company.cars.state_in_stock_scope.find_each(&:notify_market_erp)
    end
  end
end
