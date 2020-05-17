# == Schema Information
#
# Table name: dashenglaile_record_hubs # 大圣来了报告
#
#  id                  :integer          not null, primary key # 大圣来了报告
#  vin                 :string                                 # vin码
#  engine_num          :string                                 # 发动机号
#  car_brand_id        :integer                                # 大圣来了品牌 ID
#  license_plate       :string                                 # 车牌号
#  sent_at             :datetime                               # 请求发送时间
#  last_time_to_shop   :datetime                               # 最后进店时间
#  total_mileage       :integer                                # 行驶的总公里数
#  number_of_accidents :integer                                # 事故次数
#  car_brand           :string                                 # 品牌
#  result_description  :text                                   # 报告描述
#  result_images       :json                                   # 报告图片
#  result_status       :string                                 # 报告状态
#  gmt_create          :datetime                               # 此次订单创建的时间
#  gmt_finish          :datetime                               # 此次订单完成的时间
#  order_id            :string                                 # 订单ID
#  result_content      :json                                   # 报告内容
#  result_report       :json                                   # 报告总结
#  fetch_info_at       :datetime                               # 拉取报告的时间
#  make_report_at      :datetime                               # 报告生成时间
#  notify_time         :datetime                               # 通知回调时间
#  notify_type         :string                                 # 通知类型
#  notify_id           :integer                                # 推送校验 ID
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class DashenglaileRecordHub < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  has_many :dashenglaile_records
  has_many :latest_records, class_name: "DashenglaileRecord",
                            foreign_key: :last_dashenglaile_record_hub_id
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :notify_success, -> { where(result_status: "QUERY_SUCCESS") }
  # additional config .........................................................
  EXPERATION = 3.days
  # class methods .............................................................
  class << self
    def available_hub(vin)
      where(vin: vin)
        .where("created_at >= :created_at", created_at: Time.zone.now - EXPERATION)
        .notify_success
        .order(created_at: :desc).first
    end
  end
  # public instance methods ...................................................
  def notify_success?
    result_status == "QUERY_SUCCESS"
  end

  def result_status_text
    {
      "QUERY_REJECT" => "查询被拒绝",
      "QUERY_SUCCESS" => "查询成功",
      "QUERY_NO_RECORD" => "查询没有记录",
      "QUERY_FAIL" => "查询失败"
    }.fetch(result_status, "处理中")
  end

  # 兼容蚂蚁
  def query_text
    return [] unless result_content.present?
    result_content
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
