# == Schema Information
#
# Table name: car_appointments # 预约看车
#
#  id         :integer          not null, primary key # 预约看车
#  car_id     :integer                                # 车辆ID
#  phone      :string                                 # 手机
#  name       :string                                 # 姓名
#  seller_id  :integer                                # 销售员ID
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer                                # 公司ID
#

module CarAppointmentSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :car_name, :seller_name, :phone, :company_id, :car_id,
               :seller_id, :created_at

    def car_name
      object.car.try(:name)
    end

    def seller_name
      object.seller.try(:name)
    end
  end
end
