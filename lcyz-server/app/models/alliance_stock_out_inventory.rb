# == Schema Information
#
# Table name: alliance_stock_out_inventories # 联盟出库清单
#
#  id                    :integer          not null, primary key # 联盟出库清单
#  from_car_id           :integer                                # 出库车辆 ID
#  to_car_id             :integer                                # 入库(复制)车辆 ID
#  alliance_id           :integer                                # 联盟 ID
#  from_company_id       :integer                                # 出库公司 ID
#  to_company_id         :integer                                # 入库公司 ID
#  completed_at          :date                                   # 出库日期
#  closing_cost_cents    :integer                                # 成交价格
#  deposit_cents         :integer                                # 定金
#  remaining_money_cents :integer                                # 余款
#  note                  :text                                   # 备注
#  refunded_at           :date                                   # 退车时间
#  refunded_price_cents  :integer                                # 退车金额
#  seller_id             :integer                                # 成交员工 ID
#  current               :boolean                                # 是否为当前联盟出库记录
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  to_shop_id            :integer                                # 入库分店 ID
#

class AllianceStockOutInventory < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :from_car, class_name: "Car"
  belongs_to :alliance
  belongs_to :seller, class_name: "User"
  # validations ...............................................................
  validates :alliance_id, :to_company_id, :to_shop_id, :seller_id,
            :closing_cost_cents, :deposit_cents, :remaining_money_cents,
            :completed_at, presence: true, on: :create
  validate :cannot_stock_out_to_self, on: :create
  # callbacks .................................................................
  after_initialize :set_default_note
  before_create :set_as_current!
  after_save    :set_stock_out_at
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :closing_cost, :deposit, :remaining_money, :refunded_price
  # class methods .............................................................
  def self.to_histories
    where("id is not null").update_all(current: false)
  end
  # public instance methods ...................................................

  def set_as_current!
    from_car.alliance_stock_out_inventories.to_histories
    self.current = true
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_default_note
    self.note ||= alliance.try(:convention)
  end

  def set_stock_out_at
    return unless current

    from_car.update_columns(stock_out_at: completed_at)
  end

  def cannot_stock_out_to_self
    errors.add(:base, "不能出库给自己") if to_company_id == from_company_id
  end
end
