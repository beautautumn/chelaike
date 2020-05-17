# == Schema Information
#
# Table name: car_reservations # 车辆预定
#
#  id                             :integer          not null, primary key # 车辆预定
#  car_id                         :integer                                # 车辆ID
#  sales_type                     :string                                 # 销售类型
#  reserved_at                    :datetime                               # 预约时间
#  customer_channel_id            :integer                                # 客户来源
#  seller_id                      :integer                                # 成交员工
#  closing_cost_cents             :integer                                # 成交价格
#  deposit_cents                  :integer                                # 定金
#  note                           :text                                   # 备注
#  customer_location_province     :string                                 # 客户归属地省份
#  customer_location_city         :string                                 # 客户归属地城市
#  customer_location_address      :string                                 # 客户归属地详细地址
#  customer_name                  :string                                 # 客户姓名
#  customer_phone                 :string                                 # 客户电话
#  customer_idcard                :string                                 # 客户证件号
#  current                        :boolean          default(TRUE)         # 是否是当前预定
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  cancelable_price_cents         :integer                                # 退款金额
#  canceled_at                    :datetime                               # 退定日期
#  seller_name                    :string                                 # 销售员名字
#  shop_id                        :integer                                # 分店ID
#  customer_id                    :integer                                # 客户ID
#  proxy_insurance                :boolean                                # 代办保险
#  insurance_company_id           :integer                                # 保险公司
#  commercial_insurance_fee_cents :integer                                # 商业险
#  compulsory_insurance_fee_cents :integer                                # 交强险
#

class CarReservation < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car
  belongs_to :customer_channel,
             -> { with_deleted },
             class_name: "Channel",
             foreign_key: :customer_channel_id
  belongs_to :seller, class_name: "User", foreign_key: :seller_id
  belongs_to :customer
  belongs_to :insurance_company, -> { with_deleted }
  # validations ...............................................................
  validates :car_id, presence: true
  validates :reserved_at, presence: true
  # callbacks .................................................................
  before_save :set_seller_name
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :cancelable_price, :deposit, :closing_cost

  price_yuan :commercial_insurance_fee, :compulsory_insurance_fee

  # class methods .............................................................
  # public instance methods ...................................................
  def set_as_current!
    car.car_reservations.to_histories
    self.current = true
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_seller_name
    self.seller_name = seller.try(:name) if seller_id_changed?
  end
end
