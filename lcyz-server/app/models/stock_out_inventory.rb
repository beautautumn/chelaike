# == Schema Information
#
# Table name: stock_out_inventories # 出库清单
#
#  id                             :integer          not null, primary key # 出库清单
#  car_id                         :integer                                # 所属车辆
#  stock_out_inventory_type       :string                                 # 出库类型
#  completed_at                   :date                                   # 成交日期
#  seller_id                      :integer                                # 成交员工
#  customer_channel_id            :integer                                # 客户来源
#  closing_cost_cents             :integer                                # 成交价格
#  sales_type                     :string                                 # 销售类型
#  payment_type                   :string                                 # 付款类型
#  deposit_cents                  :integer                                # 定金
#  remaining_money_cents          :integer                                # 余款
#  transfer_fee_cents             :integer                                # 过户费用
#  commission_cents               :integer                                # 佣金
#  other_fee_cents                :integer                                # 其他费用
#  customer_location_province     :string                                 # 客户归属地省
#  customer_location_city         :string                                 # 客户归属地市
#  customer_location_address      :string                                 # 客户归属地地址
#  customer_name                  :string                                 # 客户姓名
#  customer_phone                 :string                                 # 联系电话
#  customer_idcard                :string                                 # 证件号
#  proxy_insurance                :boolean                                # 代办保险
#  insurance_company_id           :integer                                # 保险公司
#  commercial_insurance_fee_cents :integer                                # 商业险
#  compulsory_insurance_fee_cents :integer                                # 交强险
#  mortgage_company_id            :integer                                # 按揭公司
#  down_payment_cents             :integer                                # 首付款
#  loan_amount_cents              :integer                                # 贷款额度
#  mortgage_period_months         :integer                                # 按揭周期(月)
#  mortgage_fee_cents             :integer                                # 按揭费用
#  foregift_cents                 :integer                                # 押金
#  note                           :text                                   # 备注
#  refunded_at                    :date                                   # 退车日期
#  refund_price_cents             :integer                                # 退回车价
#  driven_back_at                 :datetime                               # 车主开回时间
#  returned_at                    :datetime                               # 车主归还时间
#  current                        :boolean                                # 是否是当前库存状态的清单
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  operator_id                    :integer
#  shop_id                        :integer                                # 分店ID
#  customer_id                    :integer                                # 客户ID
#  total_transfer_fee_cents       :integer                                # 过户总费用
#  carried_interest_cents         :integer                                # 提成金额
#  invoice_fee_cents              :integer                                # 发票费用
#

class StockOutInventory < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car, touch: true
  belongs_to :seller, class_name: "User"
  belongs_to :operator, class_name: "User"
  belongs_to :customer_channel,
             -> { with_deleted },
             class_name: "Channel",
             foreign_key: :customer_channel_id
  belongs_to :customer
  belongs_to :insurance_company, -> { with_deleted }
  belongs_to :mortgage_company, -> { with_deleted }
  has_one :out_of_stock_fact, class_name: "Dw::OutOfStockFact", dependent: :delete

  # validations ...............................................................
  validates :stock_out_inventory_type, presence: true
  validates :completed_at, presence: true, if: :self_retail_sold?
  validates :seller_id, presence: true, if: :self_retail_sold?
  validates :customer_channel_id, presence: true, if: :self_retail_sold?
  validates :closing_cost_cents, presence: true, if: :self_retail_sold?
  validates :sales_type, presence: true, if: :self_retail_sold?
  validates :payment_type, presence: true, if: :self_retail_sold?
  validates :refunded_at, presence: true, if: :acquisition_refunded?
  # callbacks .................................................................
  before_save :set_closing_cost_to_car, :set_stock_out_at, :syncs_total_transfer_fee_yuan
  # scopes ....................................................................
  scope :car_show_price_wan_gt,
        ->(price) { joins(:car).where("cars.show_price_cents > ?", price.to_i * 100 * 100_00) }
  scope :car_show_price_wan_lt,
        ->(price) { joins(:car).where("cars.show_price_cents < ?", price.to_i * 100 * 100_00) }

  # additional config .........................................................
  price_wan :closing_cost, :deposit, :remaining_money, :down_payment,
            :loan_amount, :refund_price, :carried_interest

  price_yuan :transfer_fee, :total_transfer_fee, :commission, :other_fee,
             :commercial_insurance_fee, :compulsory_insurance_fee,
             :mortgage_fee, :foregift, :invoice_fee

  enumerize :stock_out_inventory_type,
            in: %i(sold acquisition_refunded driven_back),
            predicates: true

  # enumerize :sales_type, in: %i(retail wholesale self_retail owner_company_retail)
  enumerize :sales_type, in: %i(self_retail owner_company_retail), predicates: true
  enumerize :payment_type, in: %i(cash mortgage), predicates: true
  # class methods .............................................................
  def self.ransackable_scopes(_auth_object = nil)
    %i(car_show_price_wan_gt car_show_price_wan_lt)
  end

  # public instance methods ...................................................
  def set_as_current!
    car.stock_out_inventories.to_histories
    self.current = true
  end

  def set_remaining_money
    return if closing_cost_cents.blank? || deposit_cents.blank?

    self.remaining_money_wan = [closing_cost_wan - deposit_wan, 0].max
  end

  def stock_out_at
    date_or_time = case stock_out_inventory_type
                   when "sold"
                     completed_at
                   when "acquisition_refunded"
                     refunded_at
                   when "driven_back"
                     driven_back_at
                   end

    return if date_or_time.blank?

    date_or_time.in_time_zone
  end

  def total_transfer_fee_yuan
    price = Util::ExchangeRate.cents_conversion_by(
      total_transfer_fee_cents.to_i, :yuan
    )

    return price if price > 0 # 如果不为空, 说明已经使用新版本

    transfer_fee_yuan
  end

  def mortgaged?
    mortgage_fee_cents.present?
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_closing_cost_to_car
    return unless closing_cost_cents_changed?

    car.update!(
      seller_id: seller_id,
      closing_cost_cents: closing_cost_cents
    )
  end

  def set_stock_out_at
    return unless current

    car.update_columns(stock_out_at: stock_out_at)
  end

  def syncs_total_transfer_fee_yuan
    sale_transfer = car.sale_transfer
    return if sale_transfer.blank?

    sale_transfer.update_columns(
      total_transfer_fee_cents: total_transfer_fee_cents
    )
  end

  def self_retail_sold?
    sold? && self_retail?
  end
end
