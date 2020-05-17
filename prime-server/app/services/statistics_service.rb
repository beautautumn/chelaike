# 为lib/tasks里提供一些分析功能
class StatisticsService
  # 统计车来客数据
  attr_accessor :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date.to_date
    @end_date = end_date.to_date
  end

  def statistics(period)
    return unless period.in?([:week, :month])

    file_name = "chelaike_statistics-#{@start_date.year}-#{@start_date.month}.xls"
    @_file_path = Rails.root.join("log", file_name)
    report = Spreadsheet::Workbook.new

    sheet = report.create_worksheet name: "车来客统计"
    sheet.row(0).concat %w(
      公司编号 公司名称 联系人 联系人电话 老板电话 创建时间 省份 地区
      在职员工数目 操作员工数目 平均操作数(不算禁用帐号) 本周操作量角色排序
      最近入库时间 库存数 库存操作总数 本月库存操作数
      操作用户数占比% 每月登录数达70%以上的天数
      出库车辆数 在库车辆数 操作车辆数 在库操作率 平均操作分散度 操作分散率%
    )

    calculate_sheet(sheet, period)

    report.write @_file_path
  end

  def statistics_result_file(period)
    statistics(period)
    @_file_path
  end

  private

  def user_joins_operation_records_sql(start_time)
    <<-SQL.squish!
      INNER JOIN "operation_records"
      ON "operation_records"."user_id" = "users"."id"
      AND "operation_records"."created_at" >= '#{start_time.to_s(:db)}'
    SQL
  end

  def the_most_active_user(company, time)
    the_most_active_user = company.users.joins(user_joins_operation_records_sql(time)).select(
      <<-SQL.squish!
        "users".*, COUNT("operation_records"."id") AS size
      SQL
    ).group(:id).order("size").last

    the_most_active_user = company.owner if the_most_active_user.blank?

    if the_most_active_user.blank?
      "无"
    else
      "#{the_most_active_user.name}(#{the_most_active_user.phone})"
    end
  end

  def operation_count_gt_1_users_count(company)
    sql_result = company.users.joins(user_joins_operation_records_sql(@start_date.beginning_of_day))
                        .select(
                          <<-SQL.squish!
                            "users".*, COUNT("operation_records"."id") AS operation_count
                          SQL
                        ).group(:id).having("count(operation_records.id) >= 1")
    sql_result.length
  end

  def dac_days_count(company)
    (@start_date.to_date..@end_date.to_date).inject(0) do |acc, day|
      count = DailyActiveRecord.where("created_at between :start_time and :end_time",
                                      start_time: day.beginning_of_day,
                                      end_time: day.end_of_day)
                               .where(company_id: company.id)
                               .group(:user_id)
                               .count
      total_users_count = company.users.count

      (count.size / total_users_count.to_f >= 0.7) && (acc += 1)
      acc
    end
  end

  def calculate_sheet(sheet, period)
    index = 0
    Company.includes(
      :owner, :cars, :imported_cars, :enabled_users,
      :operation_records
    ).find_each(batch_size: 20) do |company|
      days_before = period == :week ? 1.week : 1.month
      company_basic_info = [
        company.id, # 公司编号
        company.name, # 公司名称
        company.contact, # 联系人
        company.contact_mobile, # 联系人电话
        company.owner.try(:phone), # 老板电话
        company.created_at.try { |t| t.strftime("%F %R") }, # 创建时间
        company.province, # 省份
        [company.city, company.district].join(" ") # 地区
      ]

      record = company_basic_info.concat(calculated_info(company, days_before))

      index += 1
      sheet.row(index).concat(record)
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def calculated_info(company, days_before)
    # 当月操作数 - 如果不从今天开始
    last_month_operation_records_count = company.recent_operation_records(
      days_before, @end_date
    ).size

    # 在职员工数目
    enabled_users_count = company.enabled_users.size

    # 操作员工数目
    actived_users_count = company.users
                                 .where("current_sign_in_at is not null")
                                 .where("current_sign_in_at >= ?", @start_date)
                                 .size
    if actived_users_count.zero?
      average_operation_records_count = 0
    else
      average_operation_records_count = (last_month_operation_records_count.to_f /
                                         actived_users_count).round 4
    end
    operation_count = operation_count_gt_1_users_count(company)
    if enabled_users_count.zero?
      operation_percentage = 0
    else
      operation_percentage = (operation_count / enabled_users_count.to_f) * 100
    end

    [
      enabled_users_count, # 在职员工数目
      actived_users_count, # 操作员工数目
      average_operation_records_count, # 平均操作数(不算禁用帐号)
      roles_by_operation_records(company), # 本周操作量角色排序
      last_created_car_date(company), # 最近入库时间
      company.cars_count, # 库存数
      company.operation_records.valid.size, # 库存操作总数
      last_month_operation_records_count, # 本月库存操作数
      operation_percentage, # 操作数占比
      dac_days_count(company), # 每月登录数达70%以上的天数
      out_stock_cars(company).count, # 出库车辆数
      in_stock_cars(company).count, # 在库车辆数
      operated_cars(company).count, # 操作车辆数
      operation_in_stock_ratio(company), # 在库操作率
      doc_avg(out_stock_cars(company)), # 平均操作分散度
      distributed_operation_rate(company) # 操作分散率
    ]
  end

  def operation_in_stock_ratio(company)
    return 0 if in_stock_cars(company).count == 0
    (operated_cars(company).count.to_f / in_stock_cars(company).count.to_f).round(4)
  end

  def roles_by_operation_records(company)
    company.authority_roles
           .select(
             <<-SQL
               "authority_roles"."name", COUNT("operation_records"."id") AS size
             SQL
           )
           .joins(:users)
           .joins(user_joins_operation_records_sql(@start_date))
           .group(:id).order("size DESC")
           .map { |role| "#{role.name}(#{role.size}次)" }.join(" => ")
  end

  def out_stock_cars(company)
    company.cars
           .where("stock_out_at between :start_date and :end_date",
                  start_date: @start_date,
                  end_date: @end_date)
  end

  def in_stock_cars(company)
    # 在库车辆数（入库时间<=统计期末时间 and 出库时间 > 统计期初时间）
    company.cars
           .where("acquired_at <= :end_date",
                  end_date: @end_date)
           .where("stock_out_at is NULL OR stock_out_at > :start_date",
                  start_date: @start_date)
  end

  def operated_cars(company)
    # 只要该车在统计区间内发生过操作，则无论该车的历史操作发生在什么时间，都计入本次统计
    records_in_period = company.operation_records
                               .where(targetable_type: "Car")
                               .where("created_at between :start_date and :end_date",
                                      start_date: @start_date,
                                      end_date: @end_date)
                               .order(:targetable_id)
    operated_cars = []
    records_in_period.each do |record|
      # 如果该车已经被删除则不计入统计
      operated_cars << record.targetable_id if Car.find_by(id: record.targetable_id)
    end

    operated_cars.tap(&:uniq!).tap(&:sort!)
  end

  def distributed_operation_rate(company)
    # http://git.che3bao.com/autobots/prime-server/issues/805
    # http://git.che3bao.com/autobots/demands/issues/175

    # updated 201606292243
    # 统计分散度时，只计算在统计区间内发生过出库操作的车辆
    return 0 if out_stock_cars(company).blank?
    # 操作分散度 = 所有出库车辆的操作分散度平均值 * 在库车辆操作率
    (doc_avg(out_stock_cars(company)).to_f * in_stock_operation_rate(company) * 100).round 2
  end

  # 在库车辆操作率 = 统计区间内操作车辆数 / 统计区间内在库车辆数，最大值不超过100%
  def in_stock_operation_rate(company)
    return 0 if operated_cars(company).blank? || in_stock_cars(company).blank?
    # 在库车辆操作率 = 统计区间内操作车辆数 / 统计区间内在库车辆数，最大值不超过100%
    in_stock_operation_rate = operated_cars(company).count.to_f / in_stock_cars(company).count

    return 1 if in_stock_operation_rate > 1
    in_stock_operation_rate
  end

  def doc_avg(out_stock_cars)
    return 0 if out_stock_cars.blank?
    doc = 0
    out_stock_cars.each do |car|
      operation_user_hash = {}
      car.operation_records.each do |record|
        key = record.operation_record_type.to_s
        # 只统计: 入库、定价、车辆编辑/牌证编辑、整备编辑、预订、出库
        next unless key.in?(%w(car_created
                               car_priced
                               car_updated
                               prepare_record_updated
                               car_reserved stock_out))
        operation_user_hash[key] ||= []
        operation_user_hash[key] << record.user_id
      end
      doc += doc_per_car(operation_user_hash)
    end
    doc.to_f / out_stock_cars.count
  end

  # 每辆车的分散度统计
  def doc_per_car(operation_user_hash)
    return 0 if operation_user_hash.blank?
    doc_per_car = 0
    all_users = []
    operation_user_hash.each do |_operation, users|
      new_user = false
      # 每个新环节如果发现操作员工ID在之前的环节中，为没有出现过的员工ID，则操作分散计数加1
      users.each do |user_id|
        if all_users.include?(user_id)
          # 备选逻辑: 如果该环节操作的员工在之前的环节中出现过，该环节的分散数为 0
          # new_user = false
          # next
        else
          new_user = true
          all_users << user_id
        end
      end
      doc_per_car += 1 if new_user
    end
    doc_per_car.to_f / 5 # 目前除整备外共5种操作
  end

  # 统计区间内最近入库时间
  def last_created_car_date(company)
    company.cars
           .where("created_at <= :end_date", end_date: @end_date)
           .order(:id)
           .last
           .try { |car| car.created_at.strftime("%F %R") }
  end
end
