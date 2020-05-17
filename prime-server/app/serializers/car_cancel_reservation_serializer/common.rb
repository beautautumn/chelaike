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

module CarCancelReservationSerializer
  class Common < ActiveModel::Serializer
    attributes :car_id, :note, :created_at, :canceled_at, :cancelable_price_wan
  end
end
