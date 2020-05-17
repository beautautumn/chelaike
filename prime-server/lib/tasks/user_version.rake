namespace :user do
  desc "车来客用户版本统计"
  task version: :environment do
    report = Spreadsheet::Workbook.new
    file_name = "users_version.xls"
    file_path = "#{Rails.root}/log/#{file_name}"

    index = 0
    sheet = report.create_worksheet name: "车来客用户版本统计"
    sheet.row(index).concat %w(
      用户名字 版本号 公司名称
    )

    User.includes(:company).find_each do |user|
      version = user.client_info.try { |info| info.fetch("version", "超级旧") }

      record = [
        user.name,
        version.present? ? version : "超级旧",
        user.company.name
      ]

      index += 1
      sheet.row(index).concat(record)
    end

    report.write file_path

    ApplicationMailer.report(
      [
        "yanxk@che3bao.com", "wufan@che3bao.com",
        "shush@che3bao.com", "superbug@che3bao.com"
      ],
      subject: "车来客用户版本统计",
      attachments: { file_name => file_path }
    ).deliver_now
  end
end
