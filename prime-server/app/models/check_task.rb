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
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  trade_id           :integer                                # 对应erp里车辆id
#  report_type        :string                                 # 检测报告类型
#  report_url         :string                                 # 检测报告地址
#

class CheckTask < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................

  # 初始 已派单 已检测
  enumerize :task_state,
            in: %i(init sended checked)

  # 收购检测(初检) 销售检测(复检)
  enumerize :task_type,
            in: %i(acquisition_check sold_check)
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
