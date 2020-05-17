# frozen_string_literal: true
# == Schema Information
#
# Table name: orders # 支付订单
#
#  id             :integer          not null, primary key
#  order_no       :integer                                # 订单号
#  amount_cents   :integer                                # 订单金额(分)
#  channel        :string                                 # 支付渠道
#  currency       :string                                 # 货币类型
#  client_ip      :string                                 # 客户端IP
#  tenant_id      :integer                                # 所属租户
#  app_id         :string                                 # Ping++ AppID
#  open_id        :string                                 # 微信用户 OpenID
#  status         :string                                 # 订单状态
#  subject        :string
#  body           :string
#  orderable_id   :integer                                # 多态
#  orderable_type :string                                 # 多态
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  product_id     :string
#  qr_code_url    :string
#

class Order < ApplicationRecord
  extend Enumerize

  belongs_to :tenant
  belongs_to :orderable, polymorphic: true
  belongs_to :wechat_app_user_relation, foreign_key: :open_id

  enumerize :channel, in: %i(wx_pub wx_pub_qr)
  enumerize :currency, in: %i(cny)
  enumerize :status, in: %i(init charge success), predicates: { prefix: true }, scope: true
end
