# == Schema Information
#
# Table name: users # 用户
#
#  id                     :integer          not null, primary key    # 用户
#  name                   :string           not null                 # 姓名
#  username               :string                                    # 用户名
#  password_digest        :string           not null                 # 加密密码
#  email                  :string                                    # 邮箱
#  pass_reset_token       :string                                    # 重置密码token
#  phone                  :string                                    # 手机号码
#  state                  :string           default("enabled")       # 状态
#  is_alliance_contact    :boolean          default(FALSE)           # 是否联盟联系人
#  pass_reset_expired_at  :datetime                                  # 重置密码token过期时间
#  last_sign_in_at        :datetime                                  # 最后登录时间
#  current_sign_in_at     :datetime                                  # 当前登录时间
#  company_id             :integer                                   # 所属公司
#  shop_id                :integer                                   # 所属分店
#  manager_id             :integer                                   # 所属经理
#  note                   :text                                      # 员工描述
#  authority_type         :string           default("role")          # 权限选择类型
#  authorities            :text             default([]), is an Array # 权限
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  deleted_at             :datetime                                  # 删除时间
#  avatar                 :string                                    # 头像URL
#  settings               :jsonb                                     # 设置
#  mac_address            :string                                    # MAC地址
#  cross_shop_authorities :text             default([]), is an Array # 跨店权限
#  device_numbers         :text             default([]), is an Array # App设备号
#  client_info            :jsonb                                     # 客户端信息
#  first_letter           :string                                    # 拼音
#

module UserSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :username, :phone, :authority_type, :authorities, :created_at,
               :name, :email, :first_letter
  end
end
