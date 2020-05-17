# == Schema Information
#
# Table name: dashenglaile_records # 大圣来了记录
#
#  id                              :integer          not null, primary key # 大圣来了记录
#  company_id                      :integer                                # 公司ID
#  car_id                          :integer                                # 车辆ID
#  shop_id                         :integer                                # 店铺ID
#  vin                             :string                                 # vin码
#  engine_num                      :string                                 # 发动机号
#  car_brand_id                    :integer                                # 大圣来了品牌 ID
#  state                           :string                                 # 查询状态
#  last_fetch_by                   :integer                                # 最后查询的用户ID
#  user_name                       :string                                 # 最后查询的用户名
#  last_fetch_at                   :datetime                               # 最后查询的时间
#  dashenglaile_record_hub_id      :integer                                # 所属报告
#  last_dashenglaile_record_hub_id :integer                                # 最近更新的报告
#  token_price                     :decimal(8, 2)                          # 查询价格
#  vin_image                       :string                                 # vin码图片地址
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  action_type                     :string           default("new")        # 记录的查询类型
#  payment_state                   :string           default("unpaid")     # 支付状态
#  pre_token_price                 :decimal(8, 2)                          # 原价
#  request_at                      :datetime                               # 请求时间
#  response_at                     :datetime                               # 返回时间
#  token_type                      :string                                 # 支付token的类型
#  token_id                        :integer                                # 支付token
#

class DashenglaileRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car
  belongs_to :company
  belongs_to :dashenglaile_record_hub
  belongs_to :last_dashenglaile_record_hub, class_name: "DashenglaileRecordHub"
  # validations ...............................................................
  validates :token_price, presence: true
  # callbacks .................................................................
  after_commit :set_timeout_worker, on: :create
  # scopes ....................................................................
  scope :by_fetch_at_range, ->(gt, lt) { where(last_fetch_at: gt..lt) }
  scope :car_stored, -> { where.not(car_id: nil) }
  scope :success, -> { where(state: %w(unchecked checked)) }
  # additional config .........................................................
  FetchTimeout = 1.hour

  enumerize :state, in: [:generating, :unchecked, :checked,
                         :updating, :generating_fail, :updating_fail, :submitted,
                         :vin_image_fail]
  enumerize :action_type, in: [:new, :refetch]
  enumerize :payment_state, in: [:unpaid, :paid, :refunded]
  delegate :result_description, :result_images, :notify_time, :total_mileage,
           :number_of_accidents, :last_time_to_shop, :result_status,
           :result_content, :result_report, :query_text,
           to: :dashenglaile_record_hub, allow_nil: true

  delegate :emission_standard, :new_car_warranty, to: :car, allow_nil: true
  # class methods .............................................................

  # rubocop:disable Lint/UnusedMethodArgument
  def self.unit_price(car_brand_id: nil, company:)
    return MaintenanceSetting.instance.dashenglaile_unit_price unless car_brand_id

    PlatformBrand.platform_brand_price(platform: :dasheng, brand_code: car_brand_id)
  end
  # public instance methods ...................................................

  def car_info
    dashenglaile_record_hub.try(:result_report)
  end

  def car_status
    return [] unless car_info.present?
    structure = match_status("车身结构件记录") || match_status("结构件")
    engine = match_status("动力总成记录") || match_status("发动机")
    airbag = match_status("电气及安全设备记录") || match_status("安全气囊")
    meter = match_status("里程表记录") || match_status("里程表")

    [
      {
        "title": "结构部件",
        "desc": t(structure),
        "status": v(structure)
      },
      {
        "title": "发动机",
        "desc": t(engine),
        "status": v(engine)
      },
      {
        "title": "里程数",
        "desc": t(meter),
        "status": v(meter)
      },
      {
        "title": "安全气囊",
        "desc": t(airbag),
        "status": v(airbag)
      }
    ]
  end

  def brand_name
    car.try(:brand_name) || dashenglaile_record_hub.try(:car_brand)
  end

  def series_name
    car.try(:series_name)
  end

  def style_name
    car.try(:style_name)
  end

  def car_name
    return style_name if car.present?
    dashenglaile_record_hub.try(:car_brand)
  end

  def paying?
    state.generating? || state.updating? || state.submitted?
  end

  def stored?
    car_id.present?
  end

  def state_info
    state_text
  end

  def turn_checked!
    if !stored && vin.present?
      car = Car.find_by(vin: vin, company_id: company_id)
      self.car_id = car.id if car
    end
    self.state = :checked if state.unchecked?
    save!
  end

  def image_mode?
    vin_image.present?
  end

  alias stored stored?

  def format_last_fetch_at
    Util::Date.maintence_date(last_fetch_at)
  end

  def real_vin
    vin.presence || dashenglaile_record_hub.vin
  end

  def process_timeout
    return unless state.generating? || state.updating?
    ::Token.transaction do
      token = ::Token.find_by(company_id: company_id)
      if token
        token.lock!
        token.increment!(:balance, token_price)
      end
      turn_fail!("超时未返回")
    end
  end

  def turn_fail!(reason = nil)
    case state
    when "generating"
      generate_fail(reason)
    when "updating"
      if last_dashenglaile_record_hub_id
        update_rollback
      else
        generate_fail(reason)
      end
    end
  end

  def timeout_at
    start_time, end_time = Dashenglaile::Brand.working_hours(brand_id: car_brand_id)
    now = Time.zone.now
    start_at = now.change(hour: start_time[:hour], min: start_time[:min])
    end_at = now.change(hour: end_time[:hour], min: end_time[:min])
    if now > start_at && now < end_at
      now + FetchTimeout
    else
      start_at + 25.hours
    end
  end

  def set_timeout_worker
    MaintenanceTimeoutWorker.perform_at(timeout_at, id, DashenglaileRecord.name)
  end

  def platform_name
    "大圣来了"
  end

  def provider_name
    :dasheng
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def generate_fail(reason)
    update!(state: :generating_fail)
    dashenglaile_record_hub.update!(result_description: reason) if reason
  end

  def update_rollback
    attr = {
      state: :checked,
      pre_token_price: nil,
      dashenglaile_record_hub_id: last_dashenglaile_record_hub_id,
      last_ant_queen_record_hub_id: nil
    }
    attr[:token_price] = pre_token_price if pre_token_price
    update!(attr)
  end

  def match_status(item_string)
    return nil unless car_info.grep(/#{item_string}/).present?
    car_info.grep(/#{item_string}/)[0] =~ /#{item_string}(.*)/
    Regexp.last_match[1] == "正常" ? true : false
  end

  def v(bool)
    bool ? 1 : 0
  end

  def t(bool)
    bool ? "正常" : "异常"
  end
end
