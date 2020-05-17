# == Schema Information
#
# Table name: check_tasks # 检测任务
#
#  id                 :integer          not null, primary key # 检测任务
#  task_type          :string                                 # 任务类型
#  task_report_h5_url :string                                 # 生成报告url
#  car_id             :integer                                # 对应车辆
#  create_staff_id    :integer                                # 任务创建者(车商)
#  check_staff_id     :integer                                # 检测者(检测员)
#  task_state         :string                                 # 检测任务状态
#  trade_id           :integer                                # 对应erp里车辆id
#  integer            :integer                                # 对应erp里车辆id
#  report_type        :string                                 # 检测报告类型
#  string             :string                                 # 检测报告地址
#  report_url         :string                                 # 检测报告地址
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe CheckTask, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
