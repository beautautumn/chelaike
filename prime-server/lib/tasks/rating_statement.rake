namespace :rating_statement do
  desc "init easy loan rating statement"
  task init: :environment do
    (1..5).each do |item|
      EasyLoan::RatingStatement.create!(score: item, content: "综合评级初始化说明", rate_type: "comprehensive_rating")
      puts "generated comprehensive_rating #{item} statement"
    end

    (1..5).each do |item|
      EasyLoan::RatingStatement.create!(score: item, content: "健康评级初始化说明", rate_type: "operating_health")
      puts "generated operating_health #{item} statement"
    end

    (1..5).each do |item|
      EasyLoan::RatingStatement.create!(score: item, content: "行业风评初始化说明", rate_type: "industry_rating")
      puts "generated comprehensive_rating #{item} statement"
    end
  end

end
