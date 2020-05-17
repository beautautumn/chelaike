class Reporter::ReportTypes::BmIntention
  attr_reader :user, :name

  def initialize(user, params)
    @user = user
    @name = "意向信息导出#{Time.zone.now.strftime("%Y%m%d")}.xls"
    @params = params
    @query = params[:query]
  end

  def export
    HoneySheet::Excel.package(@name, self.class.title_bar, records)
  end

  def records
    Enumerator.new do |yielder|
      query_result.find_each(batch_size: 100) do |intention|
        yielder << self.class.row_format(intention)
      end
    end
  end

  def query_result
    scope = Intention.where(company_id: @user.company_id)
    scope.ransack(@query).result
         .includes(:customer, :shop, :latest_intention_push_history, :assignee)
         .order(:id)
  end

  class << self
    def title_bar
      %w(
        客户编号 所属城市 所属门店 业务员 客户名称
        联系电话 跟进天数 跟进结果 求购车辆 预算
        意向状态 客户来源 客户级别 客户所属区域 创建时间
        匹配车辆 是否成交 是否到店 是否过期 最后跟进描述
        最后跟进日期 跟进历史记录
        )
    end

    def row_format(intention)
      customer = intention.customer
      shop = intention.shop
      latest_push_history = intention.latest_intention_push_history
      assignee = intention.assignee
      [
        customer.id, # 客户编号
        shop.try(:city), # 所属城市
        shop.try(:name), # 所属门店
        assignee.try(:name), # 业务员
        intention.customer_name, # 客户名称
        intention.customer_phone, # 联系电话
        intention_push_days(intention), # 跟进天数
        intention.state_text, # 跟进结果
        intention.seek_description, # 求购车辆
        intention.price_range_text, # 预算
        intention.state_text, # 意向状态
        intention.channel.try(:name), # 客户来源
        intention.intention_level.try(:name), # 客户级别
        intention.city, # 客户所属区域
        intention.created_at, # 创建时间
        matched_cars_text(intention), # 匹配车辆
        intention_completed?(intention), # 是否成交
        checked_out?(intention), # 是否到店
        intention.expired?, # 是否过期
        latest_push_history.try(:note), # 最后跟进描述
        latest_push_history.try(:created_at), # 最后跟进日期
        intention.push_histories_text # 跟进历史记录
      ]
    end

    def intention_push_days(intention)
      latest_push_history = intention.latest_intention_push_history
      return 0 unless latest_push_history
      (Time.zone.today - latest_push_history.created_at.to_date).to_i
    end

    def intention_completed?(intention)
      intention.sold_completed? ? "已成交" : "未成交"
    end

    # 是否到店
    def checked_out?(intention)
      intention.checked_count > 0 ? "到店过" : "未到店"
    end

    def matched_cars(intention)
      condition = intention.seeking_cars_condition
      intention.company.cars
               .state_in_stock_scope
               .where(reserved: false)
               .where(condition)
    end

    def matched_cars_text(intention)
      cars = matched_cars(intention)
      cars.map { |matched_car| "#{matched_car.brand_name} #{matched_car.series_name}" }
          .join("、")
    end
  end
end
