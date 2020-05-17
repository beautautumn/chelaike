# == Schema Information
#
# Table name: service_appointments # 服务预约
#
#  id                       :integer          not null, primary key # 服务预约
#  company_id               :integer                                # 公司ID
#  service_appointment_type :string                                 # 预约类型
#  customer_name            :string                                 # 客户姓名
#  customer_phone           :string                                 # 客户电话
#  state                    :string           default("pending")    # 状态
#  note                     :text                                   # 其他说明
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

module ServiceAppointmentSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :customer_name, :customer_phone, :service_appointment_type,
               :created_at, :note
  end
end
