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

module AllianceStockOutInventorySerializer
  class Contract < ActiveModel::Serializer
    attributes :id, :alliance_id, :alliance_name, :note,
               :from_company_id, :from_company_name,
               :to_company_id, :to_company_name,
               :to_shop_id, :to_shop_name,
               :completed_at, :closing_cost_wan, :deposit_wan, :remaining_money_wan

    belongs_to :from_car, serializer: CarSerializer::Mini

    def alliance_name
      object.alliance.try(:name)
    end

    def from_company_name
      Company.find(object.from_company_id).name
    end

    def to_company_name
      Company.find(object.to_company_id).name
    end

    def to_shop_name
      Shop.find(object.to_shop_id).try(:name) if object.to_shop_id
    end
  end
end
