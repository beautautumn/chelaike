# == Schema Information
#
# Table name: finance_car_incomes # 财务管理-单车成本和收益
#
#  id                      :integer          not null, primary key # 财务管理-单车成本和收益
#  car_id                  :integer                                # 关联车辆
#  company_id              :integer                                # 所属公司
#  payment_cents           :integer                                # 入库付款
#  prepare_cost_cents      :integer                                # 整备费用
#  handling_charge_cents   :integer                                # 手续费
#  commission_cents        :integer                                # 佣金
#  percentage_cents        :integer                                # 提成/分成
#  fund_cost_cents         :integer                                # 资金成本
#  other_cost_cents        :integer                                # 其他成本
#  receipt_cents           :integer                                # 出库收款
#  other_profit_cents      :integer                                # 其他收益
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  acquisition_price_cents :integer                                # 收购价格
#  closing_cost_cents      :integer                                # 成交价格
#  fund_rate               :decimal(, )                            # 单车对应的资金利率
#  loan_cents              :integer                                # 单车融资数额
#

class Finance::CarIncome < ActiveRecord::Base
  class AmountNegativeError < StandardError; end
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car
  belongs_to :company
  # validations ...............................................................
  validates :car_id, :company_id, presence: true
  # callbacks .................................................................
  before_save :set_fund_rate
  # scopes ....................................................................
  scope :acquired_from,
        lambda { |shop_id, start|
          joins(:car).where("cars.shop_id = ? and cars.acquired_at >= ?", shop_id, start)
        }
  # additional config .........................................................
  price_yuan :prepare_cost, :handling_charge, :commission,
             :percentage, :fund_cost, :other_cost, :other_profit
  price_wan :payment, :receipt, :loan,
            :acquisition_price, :closing_cost
  # class methods .............................................................
  # public instance methods ...................................................

  def increase_amount!(category, amount)
    amount = amount.to_d
    column_name = "#{category}_cents"
    original_cents = self[column_name]

    unit = if category.in?(%w(payment receipt))
             1_000_000
           else
             100
           end

    if original_cents.blank?
      update!(column_name => amount * unit)
    else
      update!(column_name => original_cents + amount * unit)
    end
  end

  def decrease_amount!(category, amount_cents)
    amount_cents = BigDecimal(amount_cents)
    column_name = "#{category}_cents"
    original_cents = self[column_name]

    new_cents = original_cents - amount_cents

    raise AmountNegativeError if new_cents < 0

    update!(column_name => new_cents)
  end

  def gross_profit
    return "-" unless closing_cost_wan
    "#{(closing_cost_wan.to_f - acquisition_price_wan.to_f).round 2} 万"
  end

  def gross_margin
    return "-" unless closing_cost_wan
    "#{(gross_profit.to_f / closing_cost_wan.to_f * 100).round 2} %"
  end

  # rubocop:disable Metrics/AbcSize
  def net_profit
    return "-" unless closing_cost_wan
    ((
      receipt_wan.to_f * 10000 +
      other_profit_yuan.to_f -
      payment_wan.to_f * 10000 -
      prepare_cost_yuan.to_f -
      handling_charge_yuan.to_f -
      commission_yuan.to_f -
      percentage_yuan.to_f -
      fund_cost_yuan.to_f -
      other_cost_yuan.to_f
    ) / 10000).round(2).to_s + " 万"
  end
  # rubocop:enable Metrics/AbcSize

  def net_margin
    return "-" unless closing_cost_wan
    "#{(net_profit.to_f / closing_cost_wan.to_f * 100).round 2} %"
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_fund_rate
    configuration = company.financial_configuration || {}

    Finance::CarIncome.transaction do
      self.fund_rate ||= configuration.fetch(:fund_rate, 0).to_f
      self.loan_cents ||= configuration.fetch(:gearing, 0).to_f * acquisition_price_cents.to_i / 100
    end
  end
end
