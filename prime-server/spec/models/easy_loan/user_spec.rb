# == Schema Information
#
# Table name: easy_loan_users # 车融易用户模型
#
#  id                          :integer          not null, primary key    # 车融易用户模型
#  phone                       :string                                    # 手机号码
#  token                       :string                                    # 验证码
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  expired_at                  :datetime                                  # 短信验证码失效时间
#  current_device_number       :string                                    # 车融易当前登录设备号码
#  name                        :string                                    # 车融易用户姓名
#  easy_loan_sp_company_id     :integer                                   # 所属sp公司
#  authorities                 :text             default([]), is an Array # 权限清单
#  city                        :text                                      # 员工所属地区
#  status                      :boolean          default(TRUE)            # 员工状态
#  easy_loan_authority_role_id :integer                                   # 角色关联
#  rc_token                    :string                                    # 融云token
#

require "rails_helper"

RSpec.describe EasyLoan::User, type: :model do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:tianche) { companies(:tianche) }
  let(:loan_bill) { easy_loan_loan_bills(:tianche_bill_a) }

  describe ".can?(*actions)" do
    before do
      give_authority(zhangsan, "查看全部申请单")
    end

    it "reutrns boolean to judge user's authorities" do
      expect(zhangsan.can?("查看全部申请单")).to be_truthy
      expect(zhangsan.can?("修改授信额度")).to be_falsy
    end
  end

  describe "has_many operation_records" do
    it "可以得到多条操作记录" do
      operation_record = loan_bill.easy_loan_operation_records.create!(
        operation_record_type: :loan_bill_state_updated,
        user: zhangsan
      )

      EasyLoan::Message.create!(
        user: zhangsan,
        easy_loan_operation_record_id: operation_record.id
      )

      expect(zhangsan.operation_records).to include operation_record
    end
  end

  describe "#city" do
    it "returns empty if nil" do
      zhangsan.update!(city: nil)
      expect(zhangsan.city).to eq ""
    end
  end
end
