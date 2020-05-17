# == Schema Information
#
# Table name: inspection_reports # 检测报告
#
#  id           :integer          not null, primary key
#  source_link  :string                                 # 检测报告文件地址
#  report_type  :string                                 # 检测报告文件类型
#  car_id       :integer                                # 关联车辆
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  external_url :string                                 # 外部检测报告网址
#

class InspectionReport < ApplicationRecord
  mount_uploader :source_link, InspectionUploader
end
