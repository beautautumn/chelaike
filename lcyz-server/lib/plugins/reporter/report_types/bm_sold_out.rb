# 帮卖版成交信息导出
class Reporter::ReportTypes::BmSoldOut
  attr_reader :user, :name

  def initialize(user, params)
    @user = user
    @name = "成交信息导出#{Time.zone.now.strftime("%Y%m%d")}.xls"
    @query = params[:query]
  end

  def export
    title_bar = %w(
      成交编号 所属区域 所属门店 业务员
      所属车商 车商归属市场 成交日期
      成交品牌 成交车型 颜色 车龄 公里数 排量
      价格 初登日期 客户名称 联系电话 客户来源
      客户创建日期 客户跟进天数 是否按揭
      按揭公司
    )

    HoneySheet::Excel.package(@name, title_bar, records)
  end

  def records
    Enumerator.new do |yielder|
      query.find_each(batch_size: 100) do |stock_out_inventory|
        next if stock_out_inventory.car.nil?
        yielder << self.class.row_format(user, stock_out_inventory).flatten
      end
    end
  end

  def query_result
    query.select { |i| i.car.present? }
  end

  def query
    scope = StockOutInventory.where(shop_id: @user.company.shop_ids)

    scope.includes(:car, :customer)
         .ransack(@query).result
  end

  class << self
    def row_format(user, stock_out_inventory)
      car = stock_out_inventory.car
      car_shop = car.shop
      customer = stock_out_inventory.customer
      [
        stock_out_inventory.id, # 成交编号
        car_shop.try(:city), # 所属区域
        car_shop.try(:name), # 所属门店
        stock_out_inventory.seller.try(:name), # 业务员
        car.owner_company.try(:name), # 所属车商
        car.owner_company.try(:shop).try(:name), # 车商归属市场
        stock_out_inventory.created_at, # 成交日期
        car.brand_name, # 成交品牌
        car.series_name, # 成交车型
        car.exterior_color, # 颜色
        car.age, # 车龄
        car.mileage, # 公里数
        car.displacement_text, # 排量
        car.show_price_wan, # 价格
        car.licensed_at, # 初登日期
        stock_out_inventory.customer_name, # 客户名称
        stock_out_inventory.customer_phone, # 联系电话
        stock_out_inventory.customer_channel.try(:name), # 客户来源
        customer.try(:created_at), # 客户创建日期
        customer_push_history_days(stock_out_inventory, customer), # 客户跟进天数
        stock_out_inventory.mortgaged? ? "是" : "否", # 是否按揭
        stock_out_inventory.mortgage_company.try(:name) # 按揭公司
      ]
    end

    def customer_push_history_days(stock_out_inventory, customer)
      return "-" unless customer
      latest_seek_intention = customer.intentions.where(intention_type: :seek).last
      return "-" unless latest_seek_intention

      latest_push_history = latest_seek_intention.latest_intention_push_history
      latest_push_date = if latest_push_history
                           latest_push_history.created_at.to_date
                         else
                           latest_seek_intention.created_at.to_date
                         end
      (stock_out_inventory.created_at.to_date - latest_push_date).to_i
    end
  end
end
