# 维保记录相关导出
namespace :maintenances do
  def day(scope, str = nil)
    day = if str.present?
            Date.parse(str)
          else
            Time.zone.yesterday
          end
    scope.where("created_at between ? and ?",
                day.beginning_of_day,
                day.end_of_day)
  end

  def package_total(order)
    if order.created_at >= Date.parse("2017-01-15")
      TokenPackage.find(order.orderable_id).total_balance * order.quantity
    else
      # 1月14日和之前是
      # 5 充 290 得 320
      # 6 充 580 得 650
      # 7 充 1160 得 1320
      # 8 充 2320 得 2670
      case order.orderable_id
      when 5
        320 * order.quantity
      when 6
        650 * order.quantity
      when 7
        1320 * order.quantity
      when 8
        2670 * order.quantity
      end
    end
  end

  def user_name(scope)
    scope.select("count (*) as total, user_name")
         .group(:user_name)
         .order("total DESC")
         .first.try(:user_name)
  end

  def last_date(scope)
    scope.order(:id).last.try(:created_at).try(:to_date).try(:to_s, :db)
  end

  desc "导出车商充值以及维保查询统计"
  task export_stats: :environment do
    file_name = "maintence_stats_#{Date.current}.xls"
    @_file_path = "#{Rails.root}/log/#{file_name}"
    report = Spreadsheet::Workbook.new

    sheet = report.create_worksheet name: "车商充值及维保统计"
    sheet.row(0).concat %w(
      车商ID 公司名称 地区 昨日充值(元) 昨日车鉴定查询(成功/总数) 昨日蚂蚁查询 昨日大圣查询 昨日查博士查询
      充值总额(元) 最近充值日期/员工
      车鉴定查询 车鉴定最近查询日期 车鉴定查询最多员工
      蚂蚁女王查询 蚂蚁最近查询日期 蚂蚁查询最多员工
      大圣来了查询 大圣最近查询日期 大圣查询最多员工
      查博士查询 查博士最近查询日期 查博士查询最多员工
    )

    index = 0
    Company.includes(:orders).find_each do |company|
      success_orders = company.success_orders
      charge_amount = success_orders.sum(:amount_cents) / 100
      yesterday_orders = day(success_orders)
      yesterday_amount = yesterday_orders.sum(:amount_cents) / 100

      if charge_amount > 0
        puts "processing #{company.id}, #{company.name}"
        index += 1
        maintenace_scope = MaintenanceRecord.where(company_id: company.id)
        ant_queen_scope = AntQueenRecord.where(company_id: company.id)
        dasheng_scope = DashenglaileRecord.where(company_id: company.id)
        cha_doctor_scope = ChaDoctorRecord.where(company_id: company.id)

        most_maintenace_user_name = user_name(maintenace_scope)
        most_ant_user_name = user_name(ant_queen_scope)
        most_dasheng_user_name = user_name(dasheng_scope)
        most_cha_doctor_user_name = user_name(cha_doctor_scope)

        info = [
          company.id,
          company.name,
          "#{company.province} #{company.city}",
          yesterday_amount,
          "#{day(maintenace_scope).success.count} / #{day(maintenace_scope).count}",
          "#{day(ant_queen_scope).success.count} / #{day(ant_queen_scope).count}",
          "#{day(dasheng_scope).success.count} / #{day(dasheng_scope).count}",
          "#{day(cha_doctor_scope).success.count} / #{day(cha_doctor_scope).count}",
          charge_amount,
          "#{success_orders.last.try(:created_at).try(:to_date)}, "\
          "#{User.with_deleted.find(success_orders.last.user_id).name}",
          "#{maintenace_scope.success.count} / #{maintenace_scope.count}",
          last_date(maintenace_scope),
          most_maintenace_user_name,
          "#{ant_queen_scope.success.count} / #{ant_queen_scope.count}",
          last_date(ant_queen_scope),
          most_ant_user_name,
          "#{dasheng_scope.success.count} / #{dasheng_scope.count}",
          last_date(dasheng_scope),
          most_dasheng_user_name,
          "#{cha_doctor_scope.success.count} / #{cha_doctor_scope.count}",
          last_date(cha_doctor_scope),
          most_cha_doctor_user_name
        ]

        puts "processing #{index}: #{maintenace_scope.count}, #{ant_queen_scope.count}, "\
          "#{dasheng_scope.count}, #{cha_doctor_scope.count}"
        sheet.row(index).concat(info)
      end
    end

    report.write(@_file_path)
  end

  desc "导出车商充值以及维保查询流水"
  task :export_records, [:date] => :environment do |_, args|
    file_name = "maintence_records_#{args[:date]}.xls"
    @_file_path = "#{Rails.root}/log/#{file_name}"
    report = Spreadsheet::Workbook.new

    sheet_1 = report.create_worksheet name: "车商充值统计"
    sheet_1.row(0).concat %w(
      流水ID 充值时间 车商地区 公司名称 充值金额 得到车币
    )

    index = 0
    day(Order.where(status: :success), args[:date]).find_each do |order|
      charge_amount = order.amount_cents / 100
      get_amount = if order.orderable_type == "TokenPackage"
                     package_total(order)
                   else
                     order.amount_cents / 100
                   end
      if charge_amount > 0
        company = Company.with_deleted.find_by(id: order.company_id)
        next if company.blank?
        index += 1
        info = [
          order.id,
          order.updated_at.to_s(:db),
          "#{company.province} #{company.city}",
          company.name,
          charge_amount,
          get_amount
        ]

        puts "processing #{index}"
        sheet_1.row(index).concat(info)
      end
    end

    sheet_2 = report.create_worksheet name: "维保查询统计"
    sheet_2.row(0).concat %w(
      查询时间 查询平台 车商地区 公司名称 查询品牌 车架号 查询记录ID 查询结果 消费车币 是否退费
    )
    index = 0
    day(TokenBill.where(action_type: :maintenance_query, state: :finished), args[:date])
      .find_each do |bill|
      company = Company.with_deleted.find_by(id: bill.company_id)
      next if company.blank?
      detail = bill.action_abstraction.try(:[], "detail")
      platform = detail.try(:[], "platform")
      record_id = detail.try(:[], "record_id")
      vin = detail.try(:[], "vin")

      record = if record_id.present? && platform.present?
                 case platform
                 when "蚂蚁女王"
                   AntQueenRecord.find(record_id)
                 when "查博士"
                   ChaDoctorRecord.find(record_id)
                 when "大圣来了"
                   DashenglaileRecord.find(record_id)
                 when "车鉴定"
                   MaintenanceRecord.find(record_id)
                 end
               end
      if record.present?
        index += 1
        brand = record.try(:brand_name)
        result = %w(unchecked checked).include?(record.state) ? "成功" : "失败"
        refund_bill = TokenBill.where(action_type: :maintenance_refund, state: :finished)
                               .where("action_abstraction #>> '{detail, record_id}' = ? "\
          "and action_abstraction #>> '{detail,platform}' = ?", record_id.to_s, platform).first
        refund_status = ""
        if result == "失败"
          refund_status = if refund_bill.present?
                            "是"
                          else
                            "否"
                          end
        end

        info = [
          bill.created_at.to_s(:db),
          platform,
          "#{company.province} #{company.city}",
          company.name,
          brand,
          vin,
          record_id,
          result,
          bill.amount,
          refund_status
        ]
        sheet_2.row(index).concat(info)
      end
    end

    report.write(@_file_path)
  end

  desc "导出我们查询车鉴定的记录"
  task export_hubs: :environment do
    name = "车鉴定对接查询记录.xls"
    file_path = "#{Rails.root}/log/#{name}"
    report = Spreadsheet::Workbook.new
    sheet = report.create_worksheet name: "蚂蚁女王统计"

    title = %w(vin码 品牌 查询状态 订单号 完成时间 订单ID)

    sheet.row(0).concat(title)

    records = MaintenanceRecordHub.all

    records.each.with_index(1) do |record, index|
      sheet.row(index).concat(
        [
          record.vin,
          record.brand,
          record.order_message,
          record.id,
          record.updated_at,
          record.order_id
        ]
      )
    end

    report.write file_path
  end
end
