# == Schema Information
#
# Table name: car_cancel_reservations # 取消预定表
#
#  id                     :integer          not null, primary key # 取消预定表
#  car_id                 :integer
#  current                :boolean          default(TRUE)         # 是否是当前退定
#  cancelable_price_cents :integer                                # 退款金额
#  canceled_at            :datetime                               # 退定日期
#  note                   :string                                 # 备注
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

# peter todo: to add a new attr to associate with CarReservation model
class CarCancelReservation < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car
  # validations ...............................................................
  validates :car_id, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :cancelable_price
  # class methods .............................................................
  # public instance methods ...................................................
  def set_as_current!
    car.car_cancel_reservations.update_all(current: false)
    self.current = true
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
