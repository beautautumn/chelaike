# == Schema Information
#
# Table name: dw_out_of_stock_facts # 出库事实
#
#  id                        :integer          not null, primary key # 出库事实
#  car_id                    :integer                                # 车辆ID
#  car_dimension_id          :integer                                # 车辆维度ID
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  stock_out_inventory_id    :integer                                # 出库表ID
#  stock_out_inventory_type  :string                                 # 出库类型
#  stock_out_at_dimension_id :integer                                # 出库时间纬度ID
#  mode                      :string                                 # 出库方式
#  seller_id                 :integer                                # 销售员
#  closing_cost_cents        :integer          default(0)            # 成交价
#  commission_cents          :integer          default(0)            # 佣金
#  refund_price_cents        :integer          default(0)            # 退回车价
#  current                   :boolean          default(FALSE)        # 当前清单
#  other_fee_cents           :integer          default(0)            # 其他费用
#  carried_interest_cents    :integer          default(0)            # 提成金额
#

class Dw::OutOfStockFact < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car, -> { with_deleted }
  belongs_to :seller, -> { with_deleted }, class_name: "User"
  belongs_to :stock_out_inventory

  belongs_to :car_dimension, class_name: "Dw::CarDimension"
  belongs_to :stock_out_at_dimension, class_name: "Dw::StockOutAtDimension"

  # validations ...............................................................
  validates :car_id, presence: true
  validates :stock_out_inventory_id, presence: true, uniqueness: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :current, -> { where(current: true) }
  scope :state_out_of_stock, lambda {
    joins(:car_dimension)
      .where("#{Dw::CarDimension.table_name}.state in (?)", Car.state_out_of_stock)
  }

  scope :sold_or_acquisition_refunded, lambda {
    joins(:car_dimension)
      .where("#{Dw::CarDimension.table_name}.state in (?)", %w(sold acquisition_refunded))
  }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
