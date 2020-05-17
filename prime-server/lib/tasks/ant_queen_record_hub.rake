namespace :ant_queen_record_hubs do
  desc "导出我们查询蚂蚁女王的记录"
  task export_hubs: :environment do
    name = "蚂蚁女王对接查询记录.xls"
    file_path = "#{Rails.root}/log/#{name}"
    report = Spreadsheet::Workbook.new
    sheet = report.create_worksheet name: "蚂蚁女王统计"

    title = %w(vin码 品牌 查询状态 订单号 完成时间)

    sheet.row(0).concat(title)

    records = AntQueenRecordHub.all

    records.each.with_index(1) do |record, index|
      sheet.row(index).concat(
        [
          record.vin,
          record.car_brand,
          record.result_status_text,
          record.id,
          record.gmt_finish
        ]
      )
    end

    report.write file_path
  end

  desc "导出车商查询我们的记录"
  task export_queries: :environment do
    name = "车商蚂蚁女王查询记录.xls"
    file_path = "#{Rails.root}/log/#{name}"
    report = Spreadsheet::Workbook.new
    sheet = report.create_worksheet name: "车商查询蚂蚁女王统计"

    title = %w(vin码 品牌 查询状态 订单号 完成时间 共消费车币)

    sheet.row(0).concat(title)

    start_date = Date.new(2016, 12, 1)
    end_date = Date.new(2017, 4, 30)

    records = AntQueenRecordHub.where("created_at between ? and ? ", start_date, end_date).all

    records.each.with_index(1) do |record, index|
      rs = AntQueenRecord.where(ant_queen_record_hub_id: record.id)
                         .where("created_at between ? and ?", start_date, end_date)
                         .success

      total_tokens = rs.inject(0) { |a, e| a + e.token_price }

      sheet.row(index).concat(
        [
          record.vin,
          record.car_brand,
          record.result_status_text,
          record.id,
          record.gmt_finish,
          total_tokens
        ]
      )
    end

    report.write file_path
  end
end
