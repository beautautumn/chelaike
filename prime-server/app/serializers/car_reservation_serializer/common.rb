# == Schema Information
#
# Table name: car_reservations # 车辆预定
#
#  id                         :integer          not null, primary key # 车辆预定
#  car_id                     :integer                                # 车辆ID
#  sales_type                 :string                                 # 销售类型
#  reserved_at                :datetime                               # 预约时间
#  customer_channel_id        :integer                                # 客户来源
#  seller_id                  :integer                                # 成交员工
#  closing_cost_cents         :integer                                # 成交价格
#  deposit_cents              :integer                                # 定金
#  note                       :text                                   # 备注
#  customer_location_province :string                                 # 客户归属地省份
#  customer_location_city     :string                                 # 客户归属地城市
#  customer_location_address  :string                                 # 客户归属地详细地址
#  customer_name              :string                                 # 客户姓名
#  customer_phone             :string                                 # 客户电话
#  customer_idcard            :string                                 # 客户证件号
#  current                    :boolean          default(TRUE)         # 是否是当前预定
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  cancelable_price_cents     :integer                                # 退款金额
#  canceled_at                :datetime                               # 退定日期
#  seller_name                :string                                 # 销售员名字
#  shop_id                    :integer                                # 分店ID
#  customer_id                :integer                                # 客户ID
#

module CarReservationSerializer
  class Common < ActiveModel::Serializer
    include SerializerAuthorityHelper

    attributes :id, :car_id, :sales_type, :reserved_at, :customer_channel_id,
               :seller_id, :closing_cost_wan, :deposit_wan, :note,
               :customer_location_province, :customer_location_city,
               :customer_location_address, :customer_name, :customer_phone,
               :customer_idcard, :created_at, :canceled_at, :cancelable_price_wan,
               :seller_name, :commercial_insurance_fee_yuan,
               :compulsory_insurance_fee_yuan, :insurance_company_id, :proxy_insurance

    belongs_to :customer_channel, serializer: ChannelSerializer::Common
    belongs_to :insurance_company, serializer: InsuranceCompanySerializer::Common
    belongs_to :seller, serializer: UserSerializer::Basic

    def attributes(requested_attrs = nil, reload = false)
      attrs = super

      unless authority_filter("销售成交信息查看") || car_seller?
        attrs.except!(:customer_name, :customer_phone, :deposit_wan, :closing_cost_wan)
      end

      unless authority_filter("保险信息查看") || car_seller?
        attrs.except!(
          :insurance_company, :commercial_insurance_fee_yuan,
          :compulsory_insurance_fee_yuan, :note
        )
      end

      attrs
    end

    def car_seller?
      (object && scope.id == object.seller_id)
    end
  end
end
