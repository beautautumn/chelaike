include ActiveSupport::NumberHelper

namespace :chelaike do
  desc "统计车来客数据"
  task :statistics, [:year, :month] => :environment do |_, args|
    end_date = if args[:year] && args[:month]
                 Time.zone.local(args[:year], args[:month]).end_of_month
               else
                 Time.zone.now.last_month.end_of_month
               end
    service = StatisticsService.new(end_date.beginning_of_month, end_date)
    file_path = service.statistics_result_file(:month)

    ApplicationMailer.report(
      ["yanxk@che3bao.com", "wufan@chelaike.com", "zhaoda@chelaike.com"],
      subject: "#{end_date.year}.#{end_date.month}车来客统计",
      attachments: { file_name => file_path }
    ).deliver_now
  end

  desc "豪车统计"
  task luxury: :environment do
    file_path = Car::LuxuryStatisticsService.new(90).statistics_result_file
    ApplicationMailer.report(
      ["shush@che3bao.com"],
      subject: "豪车统计",
      attachments: { file_name => file_path }
    ).deliver_now
  end
end
