# == Schema Information
#
# Table name: alliance_stock_out_inventories # 联盟出库清单
#
#  id                    :integer          not null, primary key # 联盟出库清单
#  from_car_id           :integer                                # 出库车辆 ID
#  to_car_id             :integer                                # 入库(复制)车辆 ID
#  alliance_id           :integer                                # 联盟 ID
#  from_company_id       :integer                                # 出库公司 ID
#  to_company_id         :integer                                # 入库公司 ID
#  completed_at          :date                                   # 出库日期
#  closing_cost_cents    :integer                                # 成交价格
#  deposit_cents         :integer                                # 定金
#  remaining_money_cents :integer                                # 余款
#  note                  :text                                   # 备注
#  refunded_at           :date                                   # 退车时间
#  refunded_price_cents  :integer                                # 退车金额
#  seller_id             :integer                                # 成交员工 ID
#  current               :boolean                                # 是否为当前联盟出库记录
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  to_shop_id            :integer                                # 入库分店 ID
#

require "rails_helper"

RSpec.describe AllianceStockOutInventory do
  fixtures :all

  let(:a4) { cars(:a4) }
  let(:avengers) { alliances(:avengers) }
  let(:warner) { companies(:warner) }
  let(:tianche) { companies(:tianche) }
  let(:pixar) { shops(:pixar) }
  let(:nolan) { users(:nolan) }
  let(:a4_tianche_to_warner) { alliance_stock_out_inventories(:a4_tianche_to_warner) }

  describe '#set_default_note' do
    it "如果备注不为空, 保存备注" do
      a4.alliance_stock_out_inventories.create(
        alliance_id: avengers.id,
        from_company_id: warner.id,
        to_company_id: tianche.id,
        closing_cost_wan: 18,
        deposit_wan: 0,
        remaining_money_wan: 18,
        completed_at: Time.zone.today,
        seller_id: nolan.id,
        note: "互通有无",
        to_shop_id: pixar.id
      )
      expect(a4.alliance_stock_out_inventory.note).to eq "互通有无"
    end

    it "如果备注为空, 采用默认联盟公约" do
      a4.alliance_stock_out_inventories.create(
        alliance_id: avengers.id,
        from_company_id: warner.id,
        to_company_id: tianche.id,
        closing_cost_wan: 18,
        deposit_wan: 0,
        remaining_money_wan: 18,
        completed_at: Time.zone.today,
        seller_id: nolan.id,
        note: nil,
        to_shop_id: pixar.id
      )
      expect(a4.alliance_stock_out_inventory.note).to eq "不要怂, 就是干"
    end
  end

  describe "#set_as_current!" do
    subject do
      a4.alliance_stock_out_inventories.create(
        alliance_id: avengers.id,
        from_company_id: warner.id,
        to_company_id: tianche.id,
        closing_cost_wan: 18,
        deposit_wan: 0,
        remaining_money_wan: 18,
        completed_at: Time.zone.today,
        seller_id: nolan.id,
        to_shop_id: pixar.id
      )
    end

    it "处理历史纪录" do
      expect(subject.current).to be_truthy
      expect(a4_tianche_to_warner.current).to be_falsy
    end

    it "更新车辆出库时间" do
      expect(subject.current).to be_truthy
      expect(a4.reload.stock_out_at).to eq Time.zone.today
    end
  end

  describe "validations" do
    it "不能出库给自己" do
      record = a4.alliance_stock_out_inventories.create(
        alliance_id: avengers.id,
        from_company_id: warner.id,
        to_company_id: warner.id,
        closing_cost_wan: 18,
        deposit_wan: 0,
        remaining_money_wan: 18,
        completed_at: Time.zone.today,
        seller_id: nolan.id,
        to_shop_id: pixar.id
      )
      expect(record.errors.full_messages).to include "不能出库给自己"
    end
  end
end
