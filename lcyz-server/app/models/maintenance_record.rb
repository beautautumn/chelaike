# == Schema Information
#
# Table name: maintenance_records # 维保记录
#
#  id                             :integer          not null, primary key # 维保记录
#  company_id                     :integer                                # 公司ID
#  car_id                         :integer                                # 车辆ID
#  vin                            :string
#  state                          :string
#  last_fetch_by                  :integer                                # 最后查询的用户ID
#  user_name                      :string                                 # 最后查询的用户名
#  last_fetch_at                  :datetime                               # 最后查询的时间
#  maintenance_record_hub_id      :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  engine                         :string                                 # 发动机
#  license_plate                  :string                                 # 车牌
#  last_maintenance_record_hub_id :integer
#  shop_id                        :integer
#  token_price                    :decimal(8, 2)
#  pre_token_price                :decimal(8, 2)
#  vin_image                      :string                                 # vin码图片地址
#  token_type                     :string                                 # 支付token的类型
#  token_id                       :integer                                # 支付token
#

class MaintenanceRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car
  belongs_to :company
  belongs_to :maintenance_record_hub
  delegate :transmission, :displacement, :items, :report_at, :abstract_items,
           to: :maintenance_record_hub, allow_nil: true
  delegate :emission_standard, :emission_standard_text, to: :car, allow_nil: true
  delegate :brand, :style_name, :transmission, :transmission_text, :displacement,
           to: :maintenance_record_hub,
           allow_nil: true
  # validations ...............................................................
  validates :state, presence: true
  # callbacks .................................................................
  after_commit :set_timeout_worker, on: :create
  # scopes ....................................................................
  scope :real, -> { where.not(maintenance_record_hub_id: nil) }
  scope :by_fetch_at_range, ->(gt, lt) { where(last_fetch_at: gt..lt) }
  scope :car_stored, -> { where.not(car_id: nil) }
  scope :success, -> { where(state: %w(unchecked checked)) }
  # additional config .........................................................

  enumerize :state, in: [:generating, :unchecked, :checked,
                         :updating, :generating_fail, :updating_fail]

  WorkingHours = [{ hour: 8, min: 30 }, { hour: 20, min: 0 }].freeze
  FetchTimeout = 1.hour

  # class methods .............................................................

  class << self
    def unit_price
      PlatformBrand.platform_brand_price(platform: :che_jian_ding)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def find_share_record(provider, record_id)
      # 根据不同provider来选择不同model，查找不同record
      case provider
      when :ant_queen
        record = AntQueenRecord.find_by(id: record_id).ant_queen_record_hub
        return [] unless record.present?
        ["https://api.mayinvwang.com/webview/oldTuwen" \
         "/?query_id=#{record.query_id}#/",
         record.car_brand, "蚂蚁女王"]
      when :cha_doctor
        record = ChaDoctorRecord.find_by(id: record_id).cha_doctor_record_hub
        return [] unless record.present?
        [record.mobile_url, record.brand_name, "查博士"]
      when :che_jian_ding
        record = MaintenanceRecord.find_by(id: record_id).maintenance_record_hub
        return [] unless record.present?
        url = "https://pif.chejianding.com/public/" \
                "b0a6467dbc5d9bff76e1404852ae185d/mob_publicReport?" \
                "oid=#{record.order_id}&uid=#{ENV.fetch("CHEJIANDING_UID")}"
        [url, record.brand.to_s + record.style_name.to_s, "车鉴定"]
      end
    end

    def shared_key(provider, record_id)
      payload = { platform: provider, record_id: record_id }
      password = Digest::SHA256.digest(ENV["AES_PASSWORD"])
      iv = ENV["AES_IV"]
      Util::AesCrypt.encrypt(password, iv, payload.to_query)
    end
  end

  # public instance methods ...................................................
  def brand_name
    maintenance_record_hub.try(:brand) || car.try(:brand_name)
  end

  def series_name
    car.try(:series_name)
  end

  def style_name
    maintenance_record_hub.try(:style_name) || car.try(:style_name)
  end

  def car_name
    return car.system_name if car.present?
    "#{maintenance_record_hub.try(:brand)} #{maintenance_record_hub.try(:style_name)}"
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

  alias stored stored?

  def format_last_fetch_at
    Util::Date.maintence_date(last_fetch_at)
  end

  def real_vin
    vin
  end

  def state_info
    if state.generating_fail?
      maintenance_record_hub.notify_message
    else
      state_text
    end
  end

  def process_timeout
    return unless state.generating? || state.updating?
    Token.transaction do
      token = Token.find_by(company_id: record.company_id)
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
      if last_maintenance_record_hub_id
        update_rollback
      else
        generate_fail(reason)
      end
    end
  end

  def timeout_at
    start_time, end_time = WorkingHours
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
    MaintenanceTimeoutWorker.perform_at(timeout_at, id, MaintenanceRecord.name)
  end

  def image_mode?
    vin_image.present?
  end

  def platform_name
    "车鉴定"
  end

  def provider_name
    :che_jian_ding
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def generate_fail(reason)
    update!(state: :generating_fail)
    maintenance_record_hub.update!(result_description: reason) if reason
  end

  def update_rollback
    attr = {
      state: :checked,
      pre_token_price: nil,
      maintenance_record_hub_id: last_maintenance_record_hub_id,
      last_maintenance_record_hub_id: nil
    }
    attr[:token_price] = pre_token_price if pre_token_price
    update!(attr)
  end
end
