namespace :finance do
  desc "每月生成一条分店对应的支出收益记录"
  task monthly_shop_fee_generation: :environment do
    FinanceShopFeeWorker.perform_async
  end

  desc "生成所有车辆财务记录"
  task generate_finance_records: :environment do
    Company.find_in_batches(batch_size: 100).with_index do |group, _|
      group.each do |company|
        FinanceRecordWorker.new.perform(company.id)
      end
    end
  end

  desc "生成最近12个月的单店运营成本"
  task generate_finace_shop__records: :environment do
    12.times do |i|
      month = (Time.zone.now - (i + 1).month).strftime("%Y-%m")
      FinanceShopFeeWorker.perform_async(month)
    end
  end
end
