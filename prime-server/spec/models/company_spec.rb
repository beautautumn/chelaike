# == Schema Information
#
# Table name: companies # 公司
#
#  id                      :integer          not null, primary key # 公司
#  name                    :string                                 # 名称
#  contact                 :string                                 # 联系人
#  contact_mobile          :string                                 # 联系人电话
#  acquisition_mobile      :string                                 # 收购电话
#  sale_mobile             :string                                 # 销售电话
#  logo                    :string                                 # LOGO
#  note                    :string                                 # 备注
#  province                :string                                 # 省份
#  city                    :string                                 # 城市
#  district                :string                                 # 区
#  street                  :string                                 # 详细地址
#  owner_id                :integer                                # 公司拥有者ID
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  settings                :jsonb                                  # 设置
#  deleted_at              :datetime                               # 删除时间
#  md5_name                :string                                 # 兼容老系统的名称MD5值
#  slogan                  :text                                   # 宣传语
#  alliances_count         :integer                                # 联盟数量
#  cars_count              :integer                                # 车辆数量
#  active_tag              :boolean          default(FALSE)        # 活跃标识
#  honesty_tag             :boolean                                # 诚信标识
#  own_brand_tag           :boolean                                # 品牌商家标识
#  app_secret              :string                                 # 商家secret
#  youhaosuda_shop_token   :string                                 # 友好速搭商铺Token
#  open_alliance_id        :integer                                # 开放联盟ID
#  erp_id                  :string                                 # ERP 识别号
#  erp_url                 :string                                 # ERP 通知地址
#  che168_profile          :jsonb                                  # che168信息
#  qrcode                  :string                                 # 商家二维码
#  banners                 :string           is an Array           # 网站Banners
#  shops_count             :integer          default(0)
#  alliance_company_id     :integer                                # 所属品牌联盟的联盟公司
#  official_website_url    :string                                 # 官网地址
#  financial_configuration :jsonb                                  # 财务设置
#  alliance_manager_id     :integer                                # 这家公司所对应的联盟管理公司ID
#  facade                  :string           default("")           # 公司的门头照片
#  industry_rating         :decimal(, )      default(3.0)          # 默认行业风评等级
#  assets_debts_rating     :decimal(, )      default(0.6)          # 默认资产负债率
#  accredited              :boolean          default(FALSE)
#

require "rails_helper"

RSpec.describe Company, type: :model do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }

  it "新建公司默认不活跃" do
    expect(Company.create(name: "测试").active_tag).to be_falsy
  end

  describe ".change_report_time" do
    before do
      travel_to Time.zone.parse("2015-01-10 12:00")
    end

    it "set report_time again after updated" do
      expect(DailyReportWorker).to receive(:perform_in)

      tianche.update(daily_reported_at: "20:00")
    end

    it "will not execute if the time was gone" do
      expect(DailyReportWorker).not_to receive(:perform_in)

      tianche.update(daily_reported_at: "8:00")
    end

    it "will not executed if daily_reported_at have not been updated" do
      expect(DailyReportWorker).not_to receive(:perform_in)

      tianche.update(name: "abc")
    end
  end

  describe "跟联盟间是多态关系" do
    it "把公司跟联盟进行关联" do
      alliance = alliances(:avengers)
      company = companies(:github)
      relationship = company.alliance_company_relationships
                            .create!(
                              alliance_id: alliance.id,
                              nickname: "gh"
                            )
      expect(relationship).to be_persisted
    end
  end

  describe "#nickname" do
    it "得到这家公司在联盟里的昵称" do
      alliance_tianche = alliance_company_companies(:alliance_tianche)
      chuche = alliances(:chuche)

      chuche.update(alliance_company: alliance_tianche)
      alliance_tianche.add_company(tianche)
      chuche.add_company(tianche, "sony")

      expect(tianche.reload.nickname).to eq "sony"
    end
  end

  describe "#channels" do
    it "has channnels" do
      aodi_4s = channels(:aodi_4s)
      aodi_5s = channels(:aodi_5s)
      individual = channels(:individual)

      expect(tianche.channels).to match_array [aodi_4s, aodi_5s, individual]
    end
  end

  describe "#find_or_create_shop" do
    it "find or create shop" do
      shop = tianche.find_or_create_shop("new shop")

      expect(tianche.shops.last).to eq shop
    end
  end
end
