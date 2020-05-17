# == Schema Information
#
# Table name: detection_reports # 检测报告
#
#  id            :integer          not null, primary key # 检测报告
#  report_type   :string                                 # 报告类型
#  car_id        :integer                                # 关联的车辆id
#  url           :string                                 # 生成报告的地址
#  platform_name :string                                 # 对应的检测平台名
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  images_count  :integer
#

require "rails_helper"

RSpec.describe DetectionReport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
