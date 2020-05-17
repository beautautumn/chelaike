class MarketERPSyncWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(company_id)
    Car.where(company_id: company_id).state_in_stock_scope.find_each(&:notify_market_erp)
  end
end
