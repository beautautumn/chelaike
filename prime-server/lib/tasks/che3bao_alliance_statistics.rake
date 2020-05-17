namespace :che3bao do
  desc "统计联盟使用情况"
  task alliance_statistics: :environment do
    report = Spreadsheet::Workbook.new

    index = 0
    sheet = report.create_worksheet name: "统计联盟使用情况"
    sheet.row(index).concat %w(
      联盟ID 联盟名称 盟主商家名称 盟主车商省份与城市
      联盟商家成员名称 成员库存总数 成员数量 联盟创建时间
    )

    corp_ids = Che3bao::Alliance.all.pluck(:own_corp).uniq

    Che3bao::Corp.where(id: corp_ids)
                 .where("status = 1")
                 .includes(:stocks, alliances: :corps, region: :parent)
                 .find_each do |corp|
      index += 1
      sheet.row(index).concat([corp.name])

      corp.alliances.each do |alliance|
        region = corp.region

        region_name = if region.present?
                        [
                          region.region_name, region.parent.region_name
                        ].join("-")
                      else
                        "未填写"
                      end

        stocks_count = 0

        alliance_corps = alliance.corps.map do |alliance_corp|
          stocks_count += alliance_corp.stocks.size
          "#{alliance_corp.name}(#{alliance_corp.stocks.size})"
        end

        record = [
          alliance.alliance_id,
          alliance.alliance_name,
          corp.name,
          region_name,
          alliance_corps.join(", "),
          stocks_count,
          alliance.corps.size,
          alliance.create_time
        ]

        index += 1
        sheet.row(index).concat(record)
      end

      index += 1
      sheet.row(index).concat([])
    end

    report.write "#{Rails.root}/tmp/che3bao_alliance_statistics.xls"
  end
end
