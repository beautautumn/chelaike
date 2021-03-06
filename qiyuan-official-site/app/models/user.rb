# frozen_string_literal: true
# == Schema Information
#
# Table name: users # 用户
#
#  id              :integer          not null, primary key
#  username        :string                                 # 用户名
#  phone           :string                                 # 手机号
#  password_digest :string                                 # 加密密码
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tenant_id       :integer                                # 所属平台租户
#

class User < ApplicationRecord
  belongs_to :tenant

  has_secure_password

  include BCrypt
end
