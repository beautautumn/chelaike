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

module RefundInventorySerializer
  class Common < ActiveModel::Serializer
    attributes :id, :car_id, :refund_inventory_type, :refunded_at,
               :refund_price_wan, :acquisition_price_wan, :note, :created_at
  end
end
