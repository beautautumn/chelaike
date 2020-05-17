namespace :spy do
  desc "fetch brands info from autohome."
  task brands: :environment do
    Spy::V2::Brands.new.crawl
  end

  desc "fetch series info from autohome."
  task series: :environment do
    Spy::V2::Series.new.crawl
  end

  desc "fetch prices info from autohome."
  task prices: :environment do
    Spy::V2::Prices.new.crawl
  end

  desc "fetch styles info from autohome."
  task styles: :environment do
    Spy::V2::Styles.new.crawl
  end

  desc "fetch style configuration info from autohome."
  task style: :environment do
    Spy::V2::Style.new.crawl
  end

  desc "import additional models from external resources"
  task additional: :environment do
    Spy::V2::Additional.new.import
  end

  desc "if you want run all of those in the right order, run this one"
  task run_all: :environment do
    Spy::V2::Brands.new.crawl
    Spy::V2::Series.new.crawl
    Spy::V2::Styles.new.crawl
    Spy::V2::Prices.new.crawl
    Spy::V2::Style.new.crawl
    Spy::V2::Additional.new.import
  end
end
