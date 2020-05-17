# == Schema Information
#
# Table name: maintenance_record_hubs # 维保中心
#
#  id              :integer          not null, primary key # 维保中心
#  vin             :string
#  brand           :string                                 # 品牌
#  style_name      :string                                 # 车系
#  transmission    :string                                 # 变速器
#  displacement    :string                                 # 排气量
#  origin          :string                                 # 来源
#  report_at       :datetime                               # 报告时间
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  items           :json             default([])           # 详细报告
#  order_id        :string           not null              # 订单ID
#  order_status    :integer                                # 维保查询结果状态
#  order_message   :string                                 # 维保查询结果
#  notify_status   :integer                                # 异步回调结果状态
#  notify_message  :string                                 # 异步回调结果消息
#  abstract_items  :jsonb                                  # 报告概要项目
#  request_sent_at :datetime                               # 发送给车鉴定的请求时间
#

# TODO: Need refactor or not? move the order into a solo table.
class MaintenanceRecordHub < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  has_many :maintenance_records
  # validations ...............................................................
  validates :order_id, presence: true, uniqueness: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :notify_success, -> { where(notify_status: 2) }
  # additional config .........................................................
  EXPERATION = 3.days
  enumerize :origin, in: [:che_jian_ding]

  TransmissionAdapter = {
    "A/MT" => "manual_automatic",
    "AT" => "auto",
    "MT" => "manual"
  }.freeze
  # class methods .............................................................
  # public instance methods ...................................................

  def transmission
    TransmissionAdapter.fetch(self[:transmission], "other")
  end

  def notify_success?
    notify_status == 2
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
