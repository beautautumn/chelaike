# == Schema Information
#
# Table name: ant_queen_records # 蚂蚁女王记录
#
#  id                           :integer          not null, primary key # 蚂蚁女王记录
#  company_id                   :integer                                # 公司ID
#  car_id                       :integer                                # 车辆ID
#  shop_id                      :integer                                # 店铺ID
#  vin                          :string
#  state                        :string
#  last_fetch_by                :integer                                # 最后查询的用户ID
#  user_name                    :string                                 # 最后查询的用户名
#  last_fetch_at                :datetime                               # 最后查询的时间
#  ant_queen_record_hub_id      :integer
#  last_ant_queen_record_hub_id :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  engine_num                   :string
#  car_brand_id                 :integer
#  token_price                  :decimal(8, 2)
#  pre_token_price              :decimal(8, 2)
#  vin_image                    :string
#  token_type                   :string                                 # 支付token的类型
#  token_id                     :integer                                # 支付token
#

class AntQueenRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car
  belongs_to :company
  belongs_to :ant_queen_record_hub

  delegate :result_description, :result_images, :notify_time, :total_mileage,
           :number_of_accidents, :last_time_to_shop, :car_info, :car_status,
           :query_text, :text_contents_json, :text_img_json,
           to: :ant_queen_record_hub, allow_nil: true
  delegate :emission_standard, to: :car, allow_nil: true
  # validations ...............................................................
  validates :token_price, presence: true
  # callbacks .................................................................
  after_commit :set_timeout_worker, on: :create
  # scopes ....................................................................
  scope :by_fetch_at_range, ->(gt, lt) { where(last_fetch_at: gt..lt) }
  scope :car_stored, -> { where.not(car_id: nil) }
  scope :success, -> { where(state: %w(unchecked checked)) }
  # additional config .........................................................
  enumerize :state, in: [:generating, :unchecked, :checked,
                         :updating, :generating_fail, :updating_fail]

  FetchTimeout = 1.hour
  # class methods .............................................................

  # rubocop:disable Lint/UnusedMethodArgument
  def self.unit_price(car_brand_id: nil, brand: nil, company:)
    if brand
      brand_id = brand.try(:[], "id")
    elsif car_brand_id
      brand_id = car_brand_id
    end
    (PlatformBrand.find_by(platform_code: 1, brand_code: brand_id).try(:price).presence ||
      MaintenanceSetting.instance.ant_queen_unit_price).to_i
  end

  # public instance methods ...................................................
  def brand_name
    car.try(:brand_name) || ant_queen_record_hub.try(:car_brand)
  end

  def series_name
    car.try(:series_name)
  end

  def style_name
    car.try(:style_name)
  end

  def car_name
    return style_name if car.present?
    ant_queen_record_hub.try(:car_brand)
  end

  def paying?
    state.generating? || state.updating?
  end

  def stored?
    car_id.present?
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
    vin.presence || ant_queen_record_hub.vin
  end

  def state_info
    state_text
  end

  def process_timeout
    return unless state.generating? || state.updating?
    Token.transaction do
      token = Token.find_by(company_id: company_id)
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
      if last_ant_queen_record_hub_id
        update_rollback
      else
        generate_fail(reason)
      end
    end
  end

  def timeout_at
    start_time, end_time = AntQueen::Brand.working_hours(brand_id: car_brand_id)
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
    MaintenanceTimeoutWorker.perform_at(timeout_at, id, AntQueenRecord.name)
  end

  def platform_name
    "蚂蚁女王"
  end

  def provider_name
    :ant_queen
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def generate_fail(reason)
    update!(state: :generating_fail)
    ant_queen_record_hub.update!(result_description: reason) if reason
  end

  def update_rollback
    attr = {
      state: :checked,
      pre_token_price: nil,
      ant_queen_record_hub_id: last_ant_queen_record_hub_id,
      last_ant_queen_record_hub_id: nil
    }
    attr[:token_price] = pre_token_price if pre_token_price
    update!(attr)
  end
end
