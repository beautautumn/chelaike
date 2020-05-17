# == Schema Information
#
# Table name: alliances
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 联盟名称
#  owner_id            :integer                                # 所属公司ID
#  deleted_at          :datetime                               # 伪删除时间
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  active_tag          :boolean          default(FALSE)        # 活跃标识
#  honesty_tag         :boolean                                # 诚信标识
#  own_brand_tag       :boolean                                # 品牌商家标识
#  avatar              :string                                 # 联盟头像
#  note                :text                                   # 联盟说明
#  companies_count     :integer                                # 公司数量
#  alliance_company_id :integer                                # 外键关联联盟公司
#  convention          :text                                   # 联盟公约
#

require "rails_helper"

RSpec.describe Alliance, type: :model do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }

  def alliance
    @alliance ||= Alliance.create(name: "牛逼联盟")
  end

  it "新建联盟默认不活跃" do
    expect(Alliance.create(name: "测试").active_tag).to be_falsy
  end

  describe "#add_company(company)" do
    it "增加一个公司到这个联盟里" do
      alliance.update(alliance_company: nil)
      alliance.add_company(tianche)
      expect(alliance.all_companies).to include tianche
    end

    it "把新加入公司也加入到联盟公司里" do
      alliance.update(alliance_company: alliance_tianche)
      alliance.add_company(tianche)
      expect(alliance_tianche.companies).to include tianche
      expect(alliance.all_companies).to include tianche
    end
  end

  describe "#all_companies" do
    it "列出所属的联盟公司" do
      alliance.update(alliance_company: alliance_tianche)
      expect(alliance.all_companies).to include alliance_tianche
    end
  end

  describe "#after_commit" do
    before do
      %w(sale acquisition).each do |type|
        alliance.chat_groups.create(
          name: "#{alliance.name}_#{type}",
          group_type: type,
          owner_id: 1
        )
      end
    end

    it "更新相应群聊内容" do
      chat_groups = alliance.chat_groups
      alliance.update(avatar: "new-avatar-url")

      expect(chat_groups.first.logo).to eq "new-avatar-url"
    end
  end
end
