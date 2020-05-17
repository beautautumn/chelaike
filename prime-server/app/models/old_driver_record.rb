# == Schema Information
#
# Table name: old_driver_records # 老司机查询记录
#
#  id                       :integer          not null, primary key # 老司机查询记录
#  user_id                  :integer                                # 查询的用户
#  user_name                :string                                 # 查询用户名
#  company_id               :integer                                # 所属公司
#  shop_id                  :integer                                # 所属shop
#  order_id                 :string                                 # 返回的订单ID
#  state                    :string                                 # 本记录状态
#  payment_state            :string
#  action_type              :string
#  token_price              :decimal(, )                            # 花费的车币
#  token_id                 :integer                                # 扣费的token
#  token_type               :string                                 # 扣费的token类型
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  old_driver_record_hub_id :integer                                # 关联的hub
#  vin                      :string                                 # vin码
#  car_id                   :integer                                # 车辆ID
#  before_update_hub_id     :integer                                # 更新前的报告id
#

class OldDriverRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :user
  belongs_to :company
  belongs_to :car
  belongs_to :old_driver_record_hub
  belongs_to :before_update_record_hub,
             class_name: "OldDriverRecordHub",
             foreign_key: :before_update_hub_id

  # validations ...............................................................
  validates :token_price, presence: true
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :state, in: [:generating, :unchecked, :checked,
                         :updating, :generating_fail, :updating_fail]
  enumerize :action_type, in: [:new, :refetch]
  enumerize :payment_state, in: [:unpaid, :paid, :refunded]

  delegate :make, :engine_num, :license_no, :id_numbers,
           :notify_at, :insurance, :claims, :total_records_count,
           :claims_count, :record_abstract, :claims_abstract,
           :latest_claim_date, :claims_total_fee_yuan,
           :meter_error, :smoke_level, :year, :nature,
           :generated_date, :max_mileage,
           to: :record_hub,
           allow_nil: nil
  # class methods .............................................................
  class << self
    def unit_price
      10
    end
  end
  # public instance methods ...................................................

  def record_hub
    if state == :updating
      before_update_record_hub
    else
      old_driver_record_hub
    end
  end

  def stored?
    car_id.present?
  end

  def turn_checked!
    if !stored? && vin.present?
      car = Car.find_by(vin: vin, company_id: company_id)
      self.car_id = car.id if car
    end
    self.state = :checked if state.unchecked?
    save!
  end

  alias stored stored?

  def state_text
    {
      generating: "生成中",
      unchecked: "已完成",
      checked: "已查看",
      updating: "更新中",
      generating_fail: "生成失败",
      updating_fail: "更新失败"
    }.fetch(state.to_sym)
  end

  def state_info
    state_text
  end

  def format_last_fetch_at
    Util::Date.maintence_date(updated_at)
  end

  def platform_name
    "查个车"
  end

  def provider_name
    :old_driver
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
