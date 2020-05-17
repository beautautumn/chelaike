# == Schema Information
#
# Table name: finance_shop_fees # 单店运营运营成本和收益
#
#  id                       :integer          not null, primary key # 单店运营运营成本和收益
#  shop_id                  :integer                                # 关联分店
#  month                    :string                                 # 年月
#  location_rent_cents      :integer                                # 场地租金
#  salary_cents             :integer                                # 固定工资
#  social_insurance_cents   :integer                                # 社保／公积金
#  bonus_cents              :integer                                # 奖金／福利
#  marketing_expenses_cents :integer                                # 市场营销
#  energy_fee_cents         :integer                                # 水电
#  office_fee_cents         :integer                                # 办公用品
#  communication_fee_cents  :integer                                # 通讯费
#  other_cost_cents         :integer                                # 其它支出
#  other_profit_cents       :integer                                # 其它收入
#  note                     :text                                   # 备注
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Finance::ShopFee < ActiveRecord::Base
  # accessors .................................................................
  attr_accessor :car_cost_wan, :sales_revenue_wan
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :shop
  # validations ...............................................................
  validates :shop_id, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :recent,
        ->(shop_id) { where(shop_id: shop_id).order(id: :desc).limit(24) }
  # additional config .........................................................
  price_yuan :location_rent, :salary, :social_insurance,
             :bonus, :marketing_expenses, :energy_fee,
             :office_fee, :communication_fee, :other_cost,
             :other_profit
  # class methods .............................................................
  # public instance methods ...................................................
  def add_profit(cents)
    @profit_cents ||= 0
    @profit_cents += cents
  end

  def sales_revenue_wan
    @profit_cents ||= 0
    @profit_cents.to_f / 1000000
  end

  def add_cost(cents)
    @cost_cents ||= 0
    @cost_cents += cents
  end

  def car_cost_wan
    @cost_cents ||= 0
    @cost_cents.to_f / 1000000
  end

  def gross_profit
    sales_revenue_wan - car_cost_wan
  end

  def gross_margin
    return "-" if sales_revenue_wan == 0
    (gross_profit / sales_revenue_wan * 100).round 2
  end

  # rubocop:disable Metrics/AbcSize
  def net_profit
    (
      sales_revenue_wan * 10000 +
      other_profit_yuan.to_f -
      car_cost_wan * 10000 -
      location_rent_yuan.to_f -
      salary_yuan.to_f -
      social_insurance_yuan.to_f -
      bonus_yuan.to_f -
      marketing_expenses_yuan.to_f -
      energy_fee_yuan.to_f -
      office_fee_yuan.to_f -
      communication_fee_yuan.to_f -
      other_cost_yuan.to_f
    ) / 10000
  end
  # rubocop:enable Metrics/AbcSize

  def net_margin
    return "-" if sales_revenue_wan == 0 && other_profit_yuan.to_f == 0
    net_profit / ((sales_revenue_wan * 10000 + other_profit_yuan.to_f) / 10000) * 100
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
