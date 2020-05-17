class Reporter::ReportTypes::CarsInStock
  attr_reader :user, :name

  def initialize(user, params)
    @user = user
    @name = "在库车辆导出#{Time.zone.now.strftime("%Y%m%d")}.xls"
    @query = params[:query]
  end

  def export
    title_bar = %w(
      库存号 所属分店 车辆名称 收购日期 收购类型 库龄(天) 排量 外观
      内饰 里程(万) 上牌日期 厂家指导价(万) 车架号 原车牌号 现车牌 收购师 合作商家
      车辆状态 出厂日期 收购价(万) 经理底价(万) 展厅标价(万) 网络标价(万)
      销售底价(万) 钥匙数 整备开始日期 整备结束日期 整备费用汇总
    )

    HoneySheet::Excel.package(@name, title_bar, records)
  end

  def records
    Enumerator.new do |yielder|
      cars_scope = case user
                   when User
                     scope = Car.where(company_id: user.company_id)
                     CarPolicy::Scope.new(user, scope).resolve
                   when AllianceCompany::User
                     alliance_company = user.alliance_company
                     alliance_company.cars
                   end
      cars_scope.ransack(@query).result
                .state_in_stock_scope
                .includes(:acquirer, :cooperation_companies, :acquisition_transfer, :shop)
                .order(:name_pinyin)
                .find_each(batch_size: 100) do |car|
                  yielder << self.class.row_format(user, car).flatten
                end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def self.row_format(user, car)
    [
      car.stock_number, # 库存号
      car.shop.try(:name), # 所属分店
      car.system_name, # 车辆名称
      car.acquired_at.try(:strftime, "%Y/%m/%d"), # 收购日期
      car.acquisition_type_text, # 收购类型
      car.stock_age_days, # 库龄(天)
      car.displacement_text, # 排量
      car.exterior_color, # 外观
      car.interior_color, # 内饰
      car.mileage, # 里程
      car.licensed_at.try(:strftime, "%Y/%m/%d"), # 上牌日期
      car.new_car_guide_price_wan, # 厂家指导价
      car.vin, # 车架号
      car.acquisition_transfer.try(:original_plate_number), # 原车牌号
      car.try(:current_plate_number), # 现车牌
      car.acquirer.try(:name), # 收购师
      user.can?("收购信息查看") ? car.cooperation_companies.map(&:name).join(" ") : nil, # 合作商家
      car.state_text, # 车辆状态
      car.manufactured_at, # 出厂日期
      user.can?("收购价格查看") ? car.acquisition_price_wan : nil, # 收购价
      user.can?("经理底价查看") ? car.manager_price_wan : nil, # 经理底价
      car.show_price_wan, # 展厅标价
      car.online_price_wan, # 网络标价
      user.can?("销售底价查看") ? car.sales_minimun_price_wan : nil, # 销售底价
      car.acquisition_transfer.try(:key_count), # 钥匙数
      car.prepare_record.try(:start_at), # 整备开始日期
      car.prepare_record.try(:end_at), # 整备结束日期
      car.prepare_record.try(:total_amount_yuan) # 整备费用汇总
    ]
  end
  # rubocop:enable Metrics/AbcSize
end
