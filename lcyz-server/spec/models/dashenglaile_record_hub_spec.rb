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

require "rails_helper"

RSpec.describe DashenglaileRecordHub, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
