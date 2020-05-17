namespace :cha_doctor_record_hubs do
  desc "导出我们查询查博士的记录"
  task export_hubs: :environment do
    name = "查博士对接查询记录.xls"
    file_path = "#{Rails.root}/log/#{name}"
    report = Spreadsheet::Workbook.new
    sheet = report.create_worksheet name: "查博士统计"

    title = %w(vin码 品牌 查询状态 订单号 完成时间)

    sheet.row(0).concat(title)

    records = ChaDoctorRecordHub.all

    records.each.with_index(1) do |record, index|
      sheet.row(index).concat(
        [
          record.vin,
          record.brand_name,
          record.result_status_text,
          record.id,
          record.fetch_info_at
        ]
      )
    end

    report.write file_path
  end

  desc "导出车商查询我们的记录"
  task export_queries: :environment do
    name = "车商查博士查询记录.xls"
    file_path = "#{Rails.root}/log/#{name}"
    report = Spreadsheet::Workbook.new
    sheet = report.create_worksheet name: "查博士统计"

    title = %w(vin码 品牌 查询状态 订单号 完成时间 共消费车币)

    sheet.row(0).concat(title)

    start_date = Date.new(2017, 4, 1)
    end_date = Date.new(2017, 4, 30)

    records = ChaDoctorRecordHub.where("created_at between ? and ? ", start_date, end_date).all

    records.each.with_index(1) do |record, index|
      rs = record.cha_doctor_records.where(
        "created_at between ? and ?", start_date, end_date
      ).success
      total_tokens = rs.inject(0) { |a, e| a + e.token_price }

      sheet.row(index).concat(
        [
          record.vin,
          record.brand_name,
          record.result_status_text,
          record.id,
          record.fetch_info_at,
          total_tokens
        ]
      )
    end

    report.write file_path
  end
end
