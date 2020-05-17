# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key # 充值订单
#  company_id     :integer                                # 公司ID
#  user_id        :integer                                # 用户ID
#  channel        :string                                 # 充值渠道
#  amount_cents   :integer                                # 订单金额（分）
#  currency       :string                                 # 货币单位
#  client_ip      :string                                 # 客户端IP地址
#  status         :string                                 # 订单状态：创建(init)、充值(charge)、成功(success)
#  orderable_id   :integer                                #
#  orderable_type :string                                 #
#  quantity       :integer                                # 订单数量
#  created_at     :datetime         not null              # 创建时间
#  updated_at     :datetime         not null              # 更新时间
#  charge_id      :string                                 # ChargeID，由pingpp返回
#  action         :string                                 # 订单类别
#  shop_id        :integer                                # 所属分店ID
#  token_type     :string                                 # 标记个人或公司的车币
#

class Order < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :orderable, polymorphic: true
  # validations ...............................................................
  validates :company_id, :user_id,
            :channel, :amount_cents,
            :currency, :token_type,
            :status, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  price_yuan :amount
  enumerize :status, in: [:init, :charge, :success]
  enumerize :action, in: [:token_package, :token]
  enumerize :token_type, in: %i(user company), default: :company
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
