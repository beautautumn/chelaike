# == Schema Information
#
# Table name: expiration_notifications # 服务到期提醒
#
#  id              :integer          not null, primary key # 服务到期提醒
#  notify_type     :string                                 # 通知类型
#  associated_id   :integer                                # 关联记录ID
#  associated_type :string                                 # 关联记录类型
#  notify_date     :date                                   # 提醒日期
#  setting_date    :date                                   # 原记录里设置的时间
#  user_id         :integer                                # 要通知到的用户
#  company_id      :integer                                # 所属公司ID
#  actived         :boolean          default(TRUE)         # 是否可用
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notify_name     :string                                 # 通知的名字
#

require "rails_helper"

RSpec.describe ExpirationNotification, type: :model do
  fixtures :all

  let(:cruise_birth_date) { expiration_notifications(:cruise_birth_date) }
  let(:doraemon_seeking_aodi_insurance) do
    expiration_notifications(:doraemon_seeking_aodi_insurance)
  end

  let(:tianche) { companies(:tianche) }
  let(:lisi) { users(:lisi) }
  let(:zhangsan) { users(:zhangsan) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:tianche) { companies(:tianche) }

  before do
    ExpirationSetting.init(tianche)
  end

  describe "#notify_user" do
    before do
      lisi.update!(company: tianche)
      doraemon_seeking_aodi.update!(
        assignee_id: zhangsan.id,
        after_sale_assignee: lisi
      )
    end

    context "类型是客户节日提醒" do
      it "得到设置的user_id" do
        expect(cruise_birth_date.notify_user).to eq zhangsan
      end
    end

    context "类型是意向里到期提醒" do
      it "得到意向里对应设置的服务归属人" do
        expect(doraemon_seeking_aodi_insurance.notify_user).to eq lisi
      end
    end
  end
end
