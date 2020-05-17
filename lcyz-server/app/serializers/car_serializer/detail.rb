# == Schema Information
#
# Table name: cars # 车辆
#
#  id                             :integer          not null, primary key    # 车辆
#  company_id                     :integer
#  shop_id                        :integer
#  acquirer_id                    :integer                                   # 收购员
#  acquired_at                    :datetime                                  # 收购日期
#  channel_id                     :integer                                   # 收购渠道
#  acquisition_type               :string                                    # 收购类型
#  acquisition_price_cents        :integer                                   # 收购价
#  stock_number                   :string                                    # 库存编号
#  vin                            :string                                    # 车架号
#  state                          :string                                    # 车辆状态
#  state_note                     :string                                    # 车辆备注
#  brand_name                     :string                                    # 品牌名称
#  manufacturer_name              :string                                    # 厂商名称
#  series_name                    :string                                    # 车系名称
#  style_name                     :string                                    # 车型名称
#  car_type                       :string                                    # 车辆类型
#  door_count                     :integer                                   # 门数
#  displacement                   :float                                     # 排气量
#  fuel_type                      :string                                    # 燃油类型
#  is_turbo_charger               :boolean                                   # 涡轮增压
#  transmission                   :string                                    # 变速箱
#  exterior_color                 :string                                    # 外饰颜色
#  interior_color                 :string                                    # 内饰颜色
#  mileage                        :float                                     # 表显里程(万公里)
#  mileage_in_fact                :float                                     # 实际里程(万公里)
#  emission_standard              :string                                    # 排放标准
#  license_info                   :string                                    # 牌证信息
#  licensed_at                    :date                                      # 首次上牌日期
#  manufactured_at                :date                                      # 出厂日期
#  show_price_cents               :integer                                   # 展厅价格
#  online_price_cents             :integer                                   # 网络标价
#  sales_minimun_price_cents      :integer                                   # 销售底价
#  manager_price_cents            :integer                                   # 经理价
#  alliance_minimun_price_cents   :integer                                   # 联盟底价
#  new_car_guide_price_cents      :integer                                   # 新车指导价
#  new_car_additional_price_cents :integer                                   # 新车加价
#  new_car_discount               :float                                     # 新车优惠折扣
#  new_car_final_price_cents      :integer                                   # 新车完税价
#  interior_note                  :text                                      # 车辆内部描述
#  star_rating                    :integer                                   # 车辆星级
#  warranty_id                    :integer                                   # 质保等级
#  warranty_fee_cents             :integer                                   # 质保费用
#  is_fixed_price                 :boolean                                   # 是否一口价
#  allowed_mortgage               :boolean                                   # 是否可按揭
#  mortgage_note                  :text                                      # 按揭说明
#  selling_point                  :text                                      # 卖点描述
#  maintain_mileage               :float                                     # 保养里程
#  has_maintain_history           :boolean                                   # 有无保养记录
#  new_car_warranty               :string                                    # 新车质保
#  standard_equipment             :text             default([]), is an Array # 厂家标准配置
#  personal_equipment             :text             default([]), is an Array # 车主个性配置
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  stock_age_days                 :integer          default(0)               # 库龄
#  age                            :integer                                   # 车龄
#  sellable                       :boolean          default(TRUE)            # 是否可售
#  states_statistic               :jsonb                                     # 状态统计
#  state_changed_at               :datetime                                  # 状态修改时间
#  yellow_stock_warning_days      :integer          default(30)              # 库存预警
#  imported                       :string
#  reserved_at                    :datetime                                  # 预约时间
#  consignor_name                 :string                                    # 寄卖人
#  consignor_phone                :string                                    # 寄卖人电话
#  consignor_price_cents          :integer                                   # 寄卖价格
#  deleted_at                     :datetime                                  # 删除时间
#  stock_out_at                   :datetime                                  # 出库时间
#  closing_cost_cents             :integer                                   # 成交价格
#  manufacturer_configuration     :hstore
#  predicted_restocked_at         :datetime                                  # 预计回厅时间
#  reserved                       :boolean          default(FALSE)           # 是否已经预定
#  configuration_note             :text                                      # 车型配置描述
#  name                           :string                                    # 车辆名称
#  name_pinyin                    :string                                    # 车辆名称拼音
#  attachments                    :string           default([]), is an Array # 车辆附件
#  red_stock_warning_days         :integer          default(45)              # 红色预警
#  level                          :string                                    # 车辆等级
#  current_plate_number           :string                                    # 现车牌(冗余牌证表)
#  system_name                    :string                                    # 车辆系统名
#

module CarSerializer
  class Detail < ActiveModel::Serializer
    include CarSerializer::Concern
    include SerializerAuthorityHelper
    include CooperationCompanyRelationshipSerializer::Common

    attributes :attachments, :configuration_note, :manufacturer_configuration, :viewed_count

    belongs_to :company, serializer: CompanySerializer::Common
    belongs_to :shop, serializer: ShopSerializer::Common
    belongs_to :channel, serializer: ChannelSerializer::Common
    belongs_to :warranty, serializer: WarrantySerializer::Common
    belongs_to :acquirer, serializer: UserSerializer::Acquirer

    has_one :acquisition_transfer,
            serializer: TransferRecordSerializer::Acquisition
    # if: :can_read_transfer_records

    has_one :sale_transfer,
            serializer: TransferRecordSerializer::Sale
    # if: :can_read_transfer_records

    has_one :prepare_record, serializer: PrepareRecordSerializer::Common
    has_one :car_reservation, serializer: CarReservationSerializer::Common
    has_one :stock_out_inventory, serializer: StockOutInventorySerializer::Base

    has_many :images, serializer: ImageSerializer::Common
    has_many :alliance_images, serializer: ImageSerializer::Common, if: :alliance_images?

    has_many :operation_records, serializer: OperationRecordSerializer::Common

    has_one :che168_publish_record, serializer: Che168PublishRecordSerializer::Syncable
    has_many :alliances, serializer: AllianceSerializer::Basic
    has_many :all_alliances, serializer: AllianceSerializer::Basic

    has_one :micro_contract, serializer: AllianceStockOutInventorySerializer::Contract
    has_one :loan_bill, serializer: EasyLoan::LoanBillSerializer::Basic

    def alliance_images?
      instance_options[:alliance_images]
    end

    def micro_contract
      # 联盟出库(已出库状态), 显示出库合同
      return object.alliance_stock_out_inventory if view_sale_micro_contract?

      # 联盟入库(在库状态/退库状态), 显示入库合同
      return object.alliance_stock_in_inventory if view_acquisition_micro_contract?

      nil
    end

    def view_sale_micro_contract?
      object.state == "alliance_stocked_out" &&
        (current_user.can?("销售成交信息查看") || object.seller_id == current_user.id)
    end

    def view_acquisition_micro_contract?
      (current_user.can?("收购价格查看") || object.acquirer_id == current_user.id) &&
        (object.acquisition_type == "alliance" || object.state == "alliance_refuned")
    end

    # 联盟出库/入库车辆
    def alliance_transfer?
      object.state == "alliance_stocked_out" || # 联盟出库
        object.state == "alliance_refuned" ||   # 联盟退车
        object.acquisition_type == "alliance"   # 联盟入库
    end
  end
end
