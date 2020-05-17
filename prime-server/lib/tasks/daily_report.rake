namespace :company do
  desc "每日报告"

  task daily_report: :environment do
    Company.find_in_batches(batch_size: 500).with_index do |group, batch|
      group.each do |company|
        time = Util::Datetime.from_string_time(company.daily_reported_at)

        DailyReportWorker.perform_in(time + batch.minutes, company.id)
      end
    end
  end
end
