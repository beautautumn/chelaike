# == Schema Information
#
# Table name: old_driver_record_hubs # 老司机报告内容
#
#  id          :integer          not null, primary key # 老司机报告内容
#  vin         :string                                 # vin码
#  order_id    :string                                 # 对方订单ID
#  engine_num  :string                                 # 发动机号
#  license_no  :string                                 # 车牌号
#  id_numbers  :string                                 # 身份证号，以逗号分隔
#  sent_at     :datetime                               # 发送时间
#  notify_at   :datetime                               # 回调通知时间
#  make        :string                                 # 车型信息
#  insurance   :jsonb                                  # 保险区间
#  claims      :jsonb                                  # 事故
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  meter_error :boolean                                # 里程表是否异常
#  smoke_level :string                                 # 排放标准
#  year        :string                                 # 生产年份
#  nature      :string                                 # 车辆性质
#

require "rails_helper"

RSpec.describe OldDriverRecordHub, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
