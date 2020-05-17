# == Schema Information
#
# Table name: easy_loan_users # 车融易用户模型
#
#  id                    :integer          not null, primary key # 车融易用户模型
#  phone                 :string                                 # 手机号码
#  token                 :string                                 # 验证码
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  expired_at            :datetime                               # 短信验证码失效时间
#  current_device_number :string                                 # 车融易当前登录设备号码
#

module EasyLoanSerializer
  module UserSerializer
    class Basic < ActiveModel::Serializer
      attributes :id, :name, :phone, :authorities, :city, :status, :rc_token
      belongs_to :authority_role, serializer: EasyLoanSerializer::AuthorityRoleSerializer::Common
    end
  end
end
