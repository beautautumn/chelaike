# == Schema Information
#
# Table name: expiration_settings # 公司设置到期提醒时间
#
#  id            :integer          not null, primary key # 公司设置到期提醒时间
#  company_id    :integer                                # 所属公司
#  notify_type   :string                                 # 提醒类型
#  first_notify  :integer                                # 首次提醒时间
#  second_notify :integer                                # 再次提醒时间
#  third_notify  :integer                                # 三次提醒时间
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe ExpirationSetting, type: :model do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  describe ".init" do
    it "初始化一家公司里的到期提醒设置" do
      ExpirationSetting.init(tianche)

      expect(tianche.expiration_settings.count).to eq 4
      expect(tianche.expiration_settings.first.notify_type).to eq "memory_date"
    end
  end
end
