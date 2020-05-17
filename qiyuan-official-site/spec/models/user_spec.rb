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

require "rails_helper"

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
