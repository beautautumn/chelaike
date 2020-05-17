# == Schema Information
#
# Table name: customers # 客户
#
#  id                  :integer          not null, primary key     # 客户
#  company_id          :integer                                    # 公司ID
#  name                :string                                     # 姓名
#  note                :text                                       # 备注
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  phone               :string                                     # 客户主要联系电话
#  phones              :string           default([]), is an Array  # 客户联系电话
#  gender              :string                                     # 性别
#  id_number           :string                                     # 证件号
#  avatar              :string                                     # 客户头像
#  user_id             :integer                                    # 客户所属员工ID
#  first_letter        :string                                     # 客户姓名首字母
#  deleted_at          :datetime
#  source              :string           default("user_operation") # 客户产生来源
#  alliance_user_id    :integer                                    # 联盟公司员工ID
#  alliance_company_id :integer                                    # 联盟公司ID
#  memory_dates        :jsonb                                      # 纪念节日
#

require "rails_helper"

RSpec.describe Customer, type: :model do
  fixtures :users, :customers

  describe ".uniqueness_in_phones_validation" do
    it "validation pass when update" do
      customer = Customer.first
      another_user = User.where(company_id: customer.company_id)
                         .where.not(id: customer.user_id).first
      new_customer = Customer.new(customer.attributes)
      new_customer.user_id = another_user.id
      new_customer.id = nil
      new_customer.save

      expect(new_customer.errors[:phone]).to be_present
    end
  end
end
