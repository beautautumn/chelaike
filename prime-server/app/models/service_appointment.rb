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

class ServiceAppointment < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  belongs_to :acquirer, class_name: "User", foreign_key: :acquirer_id
  belongs_to :car
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :service_appointment_type, in: %i(
    vehicle_mortgage insurance_agent vehicle_beauty annual_inspection_agent
    vehicle_maintenance
  )

  ransacker :created_at do
    Arel.sql("date(service_appointments.created_at AT TIME ZONE 'GMT+8')")
  end
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
