class FinanceShopFeeWorker
  include Sidekiq::Worker

  def perform(month = nil)
    current = month || Time.zone.now.strftime("%Y-%m")
    shops = Shop.all

    shops.map do |shop|
      next if shop.company.nil?
      fee = ::Finance::ShopFee.find_or_initialize_by(shop: shop,
                                                     month: current)

      next unless fee.new_record?
      config = shop.company.financial_configuration
      location_rent = config[:rent].to_f * config[:area].to_f *
                      (config[:rent_by] == "area" ? 30 : (1 / 12))
      fee.location_rent_yuan = location_rent
      fee.save
    end
  end
end
