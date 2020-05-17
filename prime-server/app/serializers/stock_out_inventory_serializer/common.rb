# == Schema Information
#
# Table name: stock_out_inventories # 出库清单
#
#  id                             :integer          not null, primary key # 出库清单
#  car_id                         :integer                                # 所属车辆
#  stock_out_inventory_type       :string                                 # 出库类型
#  completed_at                   :date                                   # 成交日期
#  seller_id                      :integer                                # 成交员工
#  customer_channel_id            :integer                                # 客户来源
#  closing_cost_cents             :integer                                # 成交价格
#  sales_type                     :string                                 # 销售类型
#  payment_type                   :string                                 # 付款类型
#  deposit_cents                  :integer                                # 定金
#  remaining_money_cents          :integer                                # 余款
#  transfer_fee_cents             :integer                                # 过户费用
#  commission_cents               :integer                                # 佣金
#  other_fee_cents                :integer                                # 其他费用
#  customer_location_province     :string                                 # 客户归属地省
#  customer_location_city         :string                                 # 客户归属地市
#  customer_location_address      :string                                 # 客户归属地地址
#  customer_name                  :string                                 # 客户姓名
#  customer_phone                 :string                                 # 联系电话
#  customer_idcard                :string                                 # 证件号
#  proxy_insurance                :boolean                                # 代办保险
#  insurance_company_id           :integer                                # 保险公司
#  commercial_insurance_fee_cents :integer                                # 商业险
#  compulsory_insurance_fee_cents :integer                                # 交强险
#  mortgage_company_id            :integer                                # 按揭公司
#  down_payment_cents             :integer                                # 首付款
#  loan_amount_cents              :integer                                # 贷款额度
#  mortgage_period_months         :integer                                # 按揭周期(月)
#  mortgage_fee_cents             :integer                                # 按揭费用
#  foregift_cents                 :integer                                # 押金
#  note                           :text                                   # 备注
#  refunded_at                    :date                                   # 退车日期
#  refund_price_cents             :integer                                # 退回车价
#  driven_back_at                 :datetime                               # 车主开回时间
#  returned_at                    :datetime                               # 车主归还时间
#  current                        :boolean                                # 是否是当前库存状态的清单
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  operator_id                    :integer
#  shop_id                        :integer                                # 分店ID
#  customer_id                    :integer                                # 客户ID
#

module StockOutInventorySerializer
  class Common < ActiveModel::Serializer
    include SerializerAuthorityHelper

    attributes :id, :car_id, :stock_out_inventory_type, :completed_at,
               :seller_id, :sales_type, :customer_channel_id,
               :payment_type, :customer_location_province, :customer_location_city,
               :customer_location_address, :customer_name, :customer_phone,
               :customer_idcard, :proxy_insurance,
               :mortgage_period_months, :note,
               :refunded_at, :transfer_fee_yuan, :total_transfer_fee_yuan, :commission_yuan,
               :other_fee_yuan, :commercial_insurance_fee_yuan,
               :compulsory_insurance_fee_yuan, :mortgage_fee_yuan,
               :foregift_yuan, :refund_price_wan, :closing_cost_wan,
               :deposit_wan, :remaining_money_wan,
               :down_payment_wan, :loan_amount_wan, :created_at,
               :insurance_company_id, :mortgage_company_id, :driven_back_at,
               :carried_interest_wan, :invoice_fee_yuan

    belongs_to :mortgage_company, serializer: MortgageCompanySerializer::Common
    belongs_to :customer_channel, serializer: ChannelSerializer::Common
    belongs_to :insurance_company, serializer: InsuranceCompanySerializer::Common
    belongs_to :seller, serializer: UserSerializer::Basic

    def attributes(requested_attrs = nil, reload = false)
      attrs = super

      unless scope.id == object.try(:seller_id) || authority_filter("销售成交信息查看")
        attrs.except!(
          :customer_name, :customer_phone, :deposit_wan, :remaining_money_wan,
          :closing_cost_wan, :loan_amount_wan, :mortgage_company, :carried_interest_wan
        )
      end

      unless authority_filter("保险信息查看") || scope.id == object.try(:seller_id)
        attrs.except!(
          :insurance_company, :commercial_insurance_fee_yuan,
          :compulsory_insurance_fee_yuan, :note
        )
      end

      attrs
    end
  end
end
