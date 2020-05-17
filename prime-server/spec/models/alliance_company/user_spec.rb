# == Schema Information
#
# Table name: alliance_users # 联盟公司的用户
#
#  id                    :integer          not null, primary key    # 联盟公司的用户
#  name                  :string           not null                 # 姓名
#  username              :string                                    # 用户名
#  password_digest       :string           not null                 # 加密密码
#  email                 :string                                    # 邮箱
#  pass_reset_token      :string                                    # 重置密码token
#  phone                 :string                                    # 手机号码
#  state                 :string           default("enabled")       # 状态
#  pass_reset_expired_at :datetime                                  # 重置密码token过期时间
#  last_sign_in_at       :datetime                                  # 最后登录时间
#  current_sign_in_at    :datetime                                  # 当前登录时间
#  company_id            :integer                                   # 所属公司
#  manager_id            :integer                                   # 所属经理
#  note                  :text                                      # 员工描述
#  authority_type        :string           default("role")          # 权限选择类型
#  authorities           :text             default([]), is an Array # 权限
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  deleted_at            :datetime                                  # 删除时间
#  avatar                :string                                    # 头像URL
#  settings              :jsonb                                     # 设置
#  first_letter          :string                                    # 拼音
#

require "rails_helper"

RSpec.describe AllianceCompany::User, type: :model do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }

  describe "#create" do
    it "creates a new alliance_company_users" do
      user = AllianceCompany::User.create(phone: "1111111111111",
                                          username: "alliance_user",
                                          password: "123456",
                                          name: "alliance_user")
      expect(user).to be_persisted
      expect(user.first_letter).to be_present
    end
  end

  describe "#current_company_users" do
    it "列出所有同一个联盟公司的员工" do
      users = alliance_zhangsan.current_company_users
      expect(users).to match_array [alliance_zhangsan, alliance_lisi]
    end
  end
end
