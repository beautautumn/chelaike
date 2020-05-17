# == Schema Information
#
# Table name: ant_queen_record_hubs # 蚂蚁女王报告
#
#  id                  :integer          not null, primary key # 蚂蚁女王报告
#  vin                 :string
#  car_brand           :string                                 # 品牌
#  car_brand_id        :integer                                # 蚂蚁女王品牌id
#  number_of_accidents :integer                                # 事故次数
#  last_time_to_shop   :date                                   # 最后进店时间
#  total_mileage       :integer                                # 行驶的总公里数
#  notify_type         :string                                 # 通知类型
#  notify_time         :datetime                               # 通知时间
#  notify_id           :string                                 # 通知id
#  result_description  :text                                   # 报告描述
#  result_images       :json                                   # 报告图片
#  result_status       :string                                 # 报告状态
#  gmt_create          :datetime                               # 此次订单创建的时间
#  gmt_finish          :datetime                               # 此次订单完成的时间
#  query_id            :integer
#  request_success     :boolean          default(FALSE)
#  car_info            :json                                   # 报告描述
#  car_status          :json                                   # 报告描述
#  query_text          :json                                   # 查询信息
#  text_img_json       :json                                   # 报告描述
#  text_contents_json  :json                                   # 报告描述
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  request_sent_at     :datetime                               # 发送给蚂蚁女王的请求时间
#

class AntQueenRecordHub < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :notify_success, -> { where(result_status: "QUERY_SUCCESS") }
  # additional config .........................................................
  EXPERATION = 3.days
  # class methods .............................................................
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
  # protected instance methods ................................................
  # private instance methods ..................................................
end
