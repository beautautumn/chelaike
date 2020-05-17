# == Schema Information
#
# Table name: acquisition_car_infos # 收车信息
#
#  id                         :integer          not null, primary key # 收车信息
#  brand_name                 :string                                 # 品牌名称
#  series_name                :string                                 # 车系名称
#  style_name                 :string                                 # 车型名称
#  acquirer_id                :integer                                # 发布收车信息的人ID
#  licensed_at                :date                                   # licensed_at
#  new_car_guide_price_cents  :integer                                # 新车指导价
#  new_car_final_price_cents  :integer                                # 新车完税价
#  manufactured_at            :date                                   # 出厂日期
#  mileage                    :float                                  # 表显里程(万公里)
#  exterior_color             :string                                 # 外饰颜色
#  interior_color             :string                                 # 内饰颜色
#  displacement               :float                                  # 排气量
#  prepare_estimated_cents    :integer                                # 整备预算
#  manufacturer_configuration :hstore                                 # 车辆配置
#  valuation_cents            :integer                                # 收车人估价
#  state                      :string                                 # 收车信息状态
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  note_text                  :text                                   # 文字备注
#  key_count                  :integer                                # 车辆钥匙数
#  images                     :jsonb            is an Array           # 多张图片信息
#  owner_info                 :jsonb                                  # 原车主信息
#  is_turbo_charger           :boolean          default(FALSE)        # 是否自然排气
#  note_audios                :jsonb            is an Array           # 多条语音备注
#  configuration_note         :string                                 # 配置说明
#  procedure_items            :jsonb                                  # 手续信息
#  license_info               :string                                 # 牌证信息
#  company_id                 :integer                                # 发布者所属公司
#  intention_level_name       :string                                 # 客户等级
#  car_id                     :integer                                # 确认收购后关联的在库车辆
#  closing_cost_cents         :integer                                # 确认收购价
#

require "rails_helper"

RSpec.describe AcquisitionCarInfo, type: :model do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:warner) { companies(:warner) }
  let(:tianche) { companies(:tianche) }
  let(:disney) { shops(:disney) }
  let(:pixar) { shops(:pixar) }
  let(:acquisition_aodi) { acquisition_car_infos(:aodi) }
  let(:acquisition_comment) { acquisition_car_comments(:aodi_comment) }
  let(:acquisition_confirmation) { acquisition_confirmations(:aodi_confirmation) }

  describe "default state" do
    it "default is init" do
      info = AcquisitionCarInfo.create(acquirer_id: zhangsan.id)
      expect(info.state).to eq "init"
    end
  end

  describe "#seller_company" do
    it "得到这个收车信息的销售公司" do
      acquisition_comment.update(acquisition_car_info: acquisition_aodi)

      expect(acquisition_aodi.seller_company).to eq acquisition_comment.company
    end
  end

  describe "#seller_user" do
    context "未完成确认收车" do
      it "从回复里得到销售方人和公司" do
        acquisition_comment.update(acquisition_car_info: acquisition_aodi)

        lisi_seller = {
          user_name: lisi.name,
          avatar: lisi.avatar,
          company_name: lisi.company.name,
          company_id: lisi.company.id,
          user_id: lisi.id
        }

        expect(acquisition_aodi.seller_user).to eq lisi_seller
      end
    end

    context "已完成确认收车" do
      before do
        acquisition_aodi.update(state: "finished")
      end

      it "如果是自行收购,返回[]" do
        acquisition_confirmation.update(
          company: tianche,
          shop: disney,
          acquisition_car_info: acquisition_aodi
        )

        expect(acquisition_aodi.reload.seller_user).to eq(
          user_name: "Zhangsan",
          avatar: nil,
          company_name: "天车二手车",
          company_id: tianche.id,
          user_id: zhangsan.id
        )
      end

      it "如果是合作收车，从确认收车清单里得到销售方人和公司" do
        warner.update(owner: lisi)
        lisi.update(company: warner)
        acquisition_confirmation.update(
          company: warner,
          shop: pixar,
          acquisition_car_info: acquisition_aodi
        )

        owner_info = {
          user_name: lisi.name,
          avatar: lisi.avatar,
          company_name: warner.name,
          company_id: warner.id,
          user_id: lisi.id
        }

        expect(acquisition_aodi.reload.seller_user).to eq owner_info
      end
    end
  end

  describe "#cooperate_companies" do
    it "得到合作车商列表" do
      acquisition_comment.update(acquisition_car_info: acquisition_aodi)

      expect(acquisition_aodi.cooperate_companies).to match_array [acquisition_comment.company]
    end
  end

  describe "#cooperates" do
    context "未确认收购" do
      before do
        acquisition_aodi.update(state: "init")
      end

      it "返回回复里合作收车用户" do
        acquisition_comment.update(
          acquisition_car_info: acquisition_aodi,
          company: warner,
          is_seller: false
        )

        user = {
          user_name: lisi.name,
          avatar: lisi.avatar,
          company_name: lisi.company.name,
          company_id: lisi.company.id,
          user_id: lisi.id
        }
        expect(acquisition_aodi.reload.cooperates).to eq [user]
      end
    end

    context "已确认收购" do
      before do
        acquisition_aodi.update(state: "finished")
        warner.update(owner: lisi)
        lisi.update(company: warner)

        acquisition_confirmation.update(
          company: tianche,
          shop: pixar,
          acquisition_car_info: acquisition_aodi,
          cooperate_companies: [warner.id]
        )
      end

      it "从确认清单里得到合作方" do
        user = {
          user_name: lisi.name,
          avatar: lisi.avatar,
          company_name: lisi.company.name,
          company_id: lisi.company.id,
          user_id: lisi.id
        }

        expect(acquisition_aodi.reload.cooperates).to eq [user]
      end

      it "不包含销售方的公司" do
        acquisition_confirmation.update(company: warner)

        expect(acquisition_aodi.reload.cooperates).not_to include warner
      end
    end
  end

  describe "#unassigned" do
    it "列出未被分配给收购师的收车评估" do
      acquisition_aodi.update(acquirer_id: nil, company: tianche)

      expect(AcquisitionCarInfo.unassigned).to include acquisition_aodi
      expect(tianche.unassigned_acquisition_car_infos).to include acquisition_aodi
    end
  end
end
