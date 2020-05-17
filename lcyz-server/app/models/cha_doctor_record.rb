# == Schema Information
#
# Table name: cha_doctor_records
#
#  id                            :integer          not null, primary key
#  company_id                    :integer                                # 公司ID
#  car_id                        :integer                                # 车辆ID
#  shop_id                       :integer                                # 店铺ID
#  vin                           :string
#  state                         :string
#  user_name                     :string                                 # 查询的用户名
#  user_id                       :integer                                # 查询的用户ID
#  fetch_at                      :datetime                               # 拉取报告的时间
#  cha_doctor_record_hub_id      :integer                                # 所属报告
#  last_cha_doctor_record_hub_id :integer                                # 最新更新的报告
#  engine_num                    :string                                 # 发动机号
#  token_price                   :decimal(8, 2)
#  vin_image                     :string                                 # vin码图片
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  action_type                   :string           default("new")        # 记录的查询类型
#  payment_state                 :string           default("unpaid")     # 支付状态
#  request_at                    :datetime                               # 请求时间
#  response_at                   :datetime                               # 返回时间
#  token_type                    :string
#  token_id                      :integer
#

class ChaDoctorRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car
  belongs_to :company
  belongs_to :cha_doctor_record_hub
  belongs_to :last_cha_doctor_record_hub, class_name: "ChaDoctorRecordHub"
  # validations ...............................................................
  validates :token_price, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :success, -> { where(state: %w(unchecked checked)) }
  # additional config .........................................................
  enumerize :state, in: [:generating, :unchecked, :checked,
                         :updating, :generating_fail, :updating_fail, :submitted, :vin_image_fail]

  enumerize :action_type, in: [:new, :refetch]
  enumerize :payment_state, in: [:unpaid, :paid, :refunded]

  delegate :brand_name, :engine_no, :license_plate, :sent_at,
           :order_id, :make_report_at,
           :report_no, :report_details, :pc_url, :mobile_url,
           :fetch_info_at, :notify_at, :order_status, :order_message,
           :notify_status, :notify_message, :order_state,
           :notify_state, :series_name, :style_name, :summany_status_data,
           to: :cha_doctor_record_hub, allow_nil: true
  # class methods .............................................................

  def self.unit_price
    PlatformBrand.platform_brand_price(platform: :cha_doctor)
  end

  # public instance methods ...................................................

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

  def turn_fail!
    if action_type == "refetch"
      update!(state: :updating_fail, response_at: Time.zone.now,
              cha_doctor_record_hub_id: cha_doctor_record_hub_id,
              last_cha_doctor_record_hub_id: cha_doctor_record_hub_id)
    else
      update!(state: :generating_fail, response_at: Time.zone.now)
    end
  end

  alias stored stored?

  def paying?
    payment_state.paid?
  end

  def state_info
    state_text
  end

  def process_result(hub)
    state = hub.notify_state

    update!(state: :unchecked, response_at: Time.zone.now, cha_doctor_record_hub_id: hub.id) &&
      return if state == :success

    turn_fail!
  end

  def format_last_fetch_at
    Util::Date.maintence_date(updated_at)
  end

  def platform_name
    "查博士"
  end

  def provider_name
    :cha_doctor
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
