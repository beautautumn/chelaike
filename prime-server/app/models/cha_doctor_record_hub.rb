# == Schema Information
#
# Table name: cha_doctor_record_hubs # 查博士报告
#
#  id                  :integer          not null, primary key # 查博士报告
#  vin                 :string                                 # vin码
#  brand_name          :string                                 # 品牌
#  engine_no           :string                                 # 发动机号
#  license_plate       :string                                 # 车牌号
#  sent_at             :datetime                               # 请求发送时间
#  order_id            :string                                 # 订单ID
#  make_report_at      :datetime                               # 报告生成时间
#  report_no           :string                                 # 报告编号
#  report_details      :jsonb                                  # 详细报告
#  pc_url              :string                                 # 生成报告的电脑端URL
#  mobile_url          :string                                 # 生成报告的手机端URL
#  fetch_info_at       :datetime                               # 拉取报告的时间
#  notify_at           :datetime                               # 通知回调时间
#  order_status        :string                                 # 查询结果状态码
#  order_message       :string                                 # 查询结果对应消息
#  notify_status       :string                                 # 异步回调结果状态
#  notify_message      :string                                 # 异步回调结果消息
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  order_state         :string                                 # 购买报表同步返回结果的状态
#  notify_state        :string                                 # 购买报表异步通知结果的状态
#  series_name         :string                                 # 车系名
#  style_name          :string                                 # 车型
#  summany_status_data :jsonb                                  # 概况的状态
#

class ChaDoctorRecordHub < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  has_many :cha_doctor_records
  has_many :latest_records, class_name: "ChaDoctorRecord",
                            foreign_key: :last_cha_doctor_record_hub_id
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  EXPERATION = 1.day

  enumerize :order_state, in: [:success, :failed]
  enumerize :notify_state, in: [:success, :failed]
  # class methods .............................................................

  class << self
    def available_hub(vin)
      where(vin: vin)
        .where("created_at >= :created_at", created_at: Time.zone.now - EXPERATION)
        .where(notify_state: "success")
        .order(created_at: :desc).first
    end
  end
  # public instance methods ...................................................

  def result_status_text
    {
      "success" => "查询成功",
      "failed" => "查询失败"
    }.fetch(notify_state, "无结果")
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
