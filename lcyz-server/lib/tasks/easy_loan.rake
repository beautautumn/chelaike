namespace :easy_loan do
  desc "init easy_loan region comprehensive_rating default score"
  task region: :environment do
    City.all.pluck(:name, :pinyin).each do |item|
      EasyLoan::City.create(name: item[0], pinyin: item[1], score: {min: "0", utmost: "2.5", max: "5"})
      puts "init #{item[0]} done"
    end
  end

  desc "calculate company's debit"
  task calculate_debit: :environment do
    DebitWorker.new.perform
  end
end
