# == Schema Information
#
# Table name: refund_inventories # 回库清单
#
#  id                      :integer          not null, primary key # 回库清单
#  car_id                  :integer                                # 车辆ID
#  refund_inventory_type   :string                                 # 回库类型
#  refunded_at             :datetime                               # 回库日期
#  refund_price_cents      :integer                                # 退款金额
#  acquisition_price_cents :integer                                # 收购价格
#  note                    :text                                   # 描述
#  current                 :boolean          default(TRUE)         # 是否为当前回库清单
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class RefundInventory < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car
  # validations ...............................................................
  validates :refunded_at, presence: true
  validates :refund_inventory_type, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :refund_inventory_type,
            in: %i(sold acquisition_refunded driven_back),
            predicates: true,
            default: :sold

  price_wan :refund_price, :acquisition_price
  # class methods .............................................................
  # public instance methods ...................................................
  def set_as_current!
    car.refund_inventories.update_all(current: false)
    self.current = true
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
