# == Schema Information
#
# Table name: finance_car_fees # 车辆费用
#
#  id           :integer          not null, primary key # 车辆费用
#  car_id       :integer                                # 关联车辆
#  creator_id   :integer                                # 项目创建者
#  category     :string                                 # 所属项目分类
#  item_name    :string                                 # 具体项目名
#  amount_cents :integer                                # 费用数额
#  fee_date     :date                                   # 费用日期
#  note         :text                                   # 说明
#  user_id      :integer                                # 关联用户
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Finance::CarFee < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  extend EnumerizeWithGroups
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car
  belongs_to :user, class_name: "User"
  belongs_to :creator, class_name: "User"
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :occur_start,
        lambda { |shop_id, start|
          joins(:car).where("fee_date >= ? and cars.shop_id = ?", start, shop_id)
        }
  scope :by_month,
        lambda { |shop_id, month|
          start_at = Time.zone.parse(month + "-01")
          end_at = start_at.end_of_month
          joins(:car).where("fee_date >= ? and fee_date <= ? and cars.shop_id = ?",
                            start_at, end_at, shop_id)
        }

  scope :payment, -> { where(category: "payment").order("fee_date DESC, id DESC") }
  scope :receipt, -> { where(category: "receipt").order("fee_date DESC, id DESC") }

  # additional config .........................................................
  price_yuan :amount
  price_wan :amount
  # 费用类别:
  # 入库(收购)付款: payment
  # 出库收款: receipt
  # 资金成本: fund_cost
  # 整备: 维修费, 美容费, 清洗费, 其他
  # 手续: 收购办牌证, 收购补证件, 销售办牌证, 销售补证件, 落户, 其他
  # 佣金: 收购佣金, 销售佣金
  enumerize :category,
            in: %i(
              payment prepare_cost handling_charge
              commission percentage fund_cost
              other_profit receipt other_cost
            )

  enumerize :item_name,
            in: %i(
              payment receipt
              repair detailing wash other_prepare
              acquire_license acquire_bu_licence sale_license sale_bu_licence
              settle handling_charge_other
              commission_acquire commission_sale
              percentage_acquire percentage_sale percentage_fencheng
              other_cost_butie other_cost_food other_cost_post other_cost_print
              other_cost_public_relation other_cost_travel other_cost_other
              other_profit_return_commercial_ensure
              other_profit_ensure_return_commission
              other_profit_mortgage_service
              other_profit_mortgage_return_commission
              other_profit_other
            ),
            groups: {
              prepare_cost: %i(repair detailing wash other_prepare),
              handling_charge: %i(acquire_license acquire_sale_license),
              commission: %i(commission_acquire commission_sale),
              percentage: %i(percentage_acquire percentage_sale percentage_fencheng)
            }
  # class methods .............................................................
  # public instance methods ...................................................
  def profit?
    %w(other_profit receipt).include? category
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
