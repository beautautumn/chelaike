# == Schema Information
#
# Table name: car_publish_records
#
#  id            :integer          not null, primary key
#  company_id    :integer                                # 公司ID
#  car_id        :integer                                # 发布车辆ID
#  user_id       :integer                                # 发布者ID
#  state         :string           default("processing") # 发布状态
#  error_message :string                                 # 错误信息
#  publish_state :string                                 # 车辆在对应平台的状态
#  type          :string                                 # STI
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  current       :boolean          default(FALSE)        # 是否是当前的记录
#  contactor     :string                                 # 各平台的联系人
#  published_id  :jsonb                                  # 同步到平台的标识，可能为{id: 1234, company_id:4321}
#

# module CarPublisher
module PublishCar
  class Com58Record < PublishCar::CarPublishRecord
    def obj_hash
      profile.com58
    end

    def obj_hash=(data)
      profile.com58 = data
    end
  end
end
