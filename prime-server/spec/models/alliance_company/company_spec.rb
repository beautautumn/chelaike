# == Schema Information
#
# Table name: alliance_companies # 联盟公司
#
#  id                  :integer          not null, primary key # 联盟公司
#  name                :string                                 # 名称
#  contact             :string                                 # 联系人
#  contact_mobile      :string                                 # 联系人电话
#  sale_mobile         :string                                 # 销售电话
#  logo                :string                                 # LOGO
#  note                :string                                 # 备注
#  province            :string                                 # 省份
#  city                :string                                 # 城市
#  district            :string                                 # 区
#  street              :string                                 # 详细地址
#  owner_id            :integer                                # 公司拥有者ID
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  settings            :jsonb                                  # 设置
#  deleted_at          :datetime                               # 删除时间
#  slogan              :text                                   # 宣传语
#  qrcode              :string                                 # 商家二维码
#  banners             :string           is an Array           # 网站Banners
#  alliances_count     :integer                                # 联盟数量
#  water_mark_position :jsonb                                  # 水印位置
#  water_mark          :string                                 # 水印图片url
#

require "rails_helper"

RSpec.describe AllianceCompany::Company, type: :model do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:chuche) { alliances(:chuche) }

  describe "#companies" do
    it "列出所有这个联盟公司下的子公司" do
      alliance_tianche.add_companies([alliance_tianche, tianche])
      expect(alliance_tianche.companies).to match_array [tianche]
    end
  end

  describe "#add_companies(companies)" do
    it "把这些车商的‘联盟公司’设置为本联盟公司" do
      alliance_tianche.add_companies([tianche, warner])
      expect(tianche.reload.alliance_company).to eq alliance_tianche
    end
  end
end
