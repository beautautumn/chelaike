# 帮卖版车源导出
class Reporter::ReportTypes::BmCars
  attr_reader :user, :name

  def initialize(user, params)
    @user = user
    @name = "车源导出#{Time.zone.now.strftime("%Y%m%d")}.xls"
    @query = params[:query]
  end

  def export
    title_bar = %w(
      车源编号 所属城市 所属门店 车源负责人
      所属车商 车商归属市场 品牌 车型
      颜色 车龄 公里数 排量 车价
      初登日期 库存天数 车辆状态
      入库时间 出库时间 成交状态
    )

    HoneySheet::Excel.package(@name, title_bar, records)
  end

  def records
    Enumerator.new do |yielder|
      query_result.find_each(batch_size: 100) do |car|
        yielder << self.class.row_format(user, car).flatten
      end
    end
  end

  def query_result
    scope = Car.where(company_id: user.company_id)
    cars_scope = CarPolicy::Scope.new(user, scope).resolve
    cars_scope.ransack(@query).result
              .includes(:acquirer, :cooperation_companies,
                        :acquisition_transfer, :shop, :owner_company)
              .order(:name_pinyin)
  end

  # rubocop:disable Metrics/AbcSize
  class << self
    def row_format(user, car)
      [
        car.stock_number, # 库存号
        car.shop.try(:city), # 所属城市
        car.shop.try(:name), # 所属门店
        car.acquirer.try(:name), # 车源负责人
        car.owner_company.try(:name), # 所属车商
        car.company.name, # 车商归属市场
        car.brand_name, # 品牌
        car.series_name, # 车型
        car.exterior_color, # 颜色
        car.age, # 车龄
        car.mileage, # 公里数
        car.displacement_text, # 排量（最好能区分T）
        car.show_price_wan, # 车价
        car.licensed_at, # 初登日期
        car.stock_age_days, # 库存天数
        car.state_text, # 车辆状态
        car.created_at, # 入库时间
        car.stock_out_at, # 出库时间
        sales_type(car) # 成交状态
      ]
    end

    def sales_type(car)
      return "-" unless car.stock_out_inventory
      car.stock_out_inventory.try(:sales_type_text)
    end
  end
end
