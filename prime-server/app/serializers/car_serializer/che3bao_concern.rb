# rubocop:disable Style/MethodName,Metrics/ModuleLength
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
  module Che3baoConcern
    # 库存ID
    def stockId
      object.id
    end

    # 车辆名称
    def vehicleName
      object.system_name
    end

    # 分店名称
    def shopName
      object.try(:shop).try(:name)
    end

    # 车辆所在省份
    def carProvince
      object.try(:acquisition_transfer).try(:current_location_province)
    end

    # 车辆所在城市
    def carCity
      object.try(:acquisition_transfer).try(:current_location_city)
    end

    # 车价
    def carPrice
      object.show_price_wan
    end

    # 新车指导价
    def newCarRefPrice
      object.new_car_guide_price_wan
    end

    # 首图地址
    def firstPic
      object.cover.try(:url)
    end

    # 大图地址
    def bigPicAddr
      object.images.map(&:url).join(",")
    end

    # 出厂日期
    def factoryMonth
      Util::Formatter.to_date(manufactured_at)
    end

    # 上牌时间
    def registerMonth
      Util::Formatter.to_month(object.licensed_at)
    end

    # 保养记录标记 0: 无; 1: 是
    def maintTag
      has_maintain_history ? "1" : "0"
    end

    # 保养里程
    def maintainMileage
      "#{maintain_mileage.to_i}公里"
    end

    # 卖点描述
    def marketDesc
      object.selling_point
    end

    # 库存编号
    def stockNo
      object.stock_number
    end

    # 使用人性质 0: 私户; 1: 公户
    def usedKind
      ""
    end

    # 涡轮增压标记
    def turboCharger
      object.is_turbo_charger ? "1" : "0"
    end

    # 表显里程
    def mileageNum
      object.mileage
    end

    # 车辆标准配置
    def standardEquip
      object.standard_equipment.join(",")
    end

    # 品牌名称
    def brandName
      object.brand_name
    end

    # 品牌编码
    def brandCode
      object.brand_name
    end

    # 车系名称
    def seriesName
      object.series_name
    end

    # 车系编码
    def seriesCode
      object.series_name
    end

    # 车型名称
    def catalogueName
      object.style_name
    end
    alias modelName catalogueName

    def modelCode
      object.style_name
    end

    # 车主个性配置
    def custEquip
      object.personal_equipment.join(",")
    end

    # 质保等级名称
    def warrantyLevel
      object.warranty.try(:name)
    end

    # 交强险标记
    def issurValidTag
      object.acquisition_transfer.items.include(:compulsory_insurance) ? "1" : "0"
    end

    # 交强险到期
    def issurValidDate
      Util::Formatter.to_month(object.acquisition_transfer.compulsory_insurance_end_at)
    end

    # 销售收款状态
    def revState
      ""
    end

    # 状态变更日期
    def stateChgDate
      ""
    end

    # 预计回厅日期
    def preBackDate
      ""
    end

    # 年检有效期
    def checkValidMonth
      Util::Formatter.to_month(object.acquisition_transfer.annual_inspection_end_at)
    end

    # 新车到手价/新车完税价
    def newCarHandprice
      object.new_car_final_price_wan
    end

    # 新车指导价
    def newCarRefprice
      return if object.new_car_guide_price_cents.blank?

      "#{object.new_car_guide_price_wan}万元"
    end

    # 新车加价
    def extraAddPrice
      return if object.new_car_additional_price_cents.blank?

      "#{object.new_car_additional_price_wan}万元"
    end

    # 特卖查看标记（0：未查看；1：已查看） TODO
    def discViewTag
      "0"
    end

    # 库存是否共享
    def shared
      "0"
    end

    # 是否显示预定客户名称和电话
    def showCustInfo
      object.reserved ? "1" : "0"
    end

    # 入库日期
    def instockDate
      Util::Formatter.to_date(object.created_at)
    end

    # 环保标准
    def envLevel
      object.emission_standard_text
    end

    # 车况描述
    def condDesc
      object.interior_note
    end

    # 按揭说明
    def mortgageDesc
      object.mortgage_note
    end

    # 标牌价
    def showPrice
      return if object.show_price_cents.blank?

      "#{object.show_price_wan}万元"
    end

    # 网络价格
    def internetPrice
      return if object.online_price_cents.blank?

      "#{object.online_price_wan}万元"
    end

    # 经理价
    def managerPrice
      return if object.manager_price_cents.blank?

      "#{object.manager_price_wan}万元"
    end

    # 代理商标记(0:不是,1:是)  废弃了
    def agentTag
      "0"
    end

    def attachParam
      ""
    end

    def credentials
      items = object.acquisition_transfer.items
      {
        "原车主身份证原件" => present_text(items.include?(:original_owner_identity_card)),
        "行驶证" => present_text(items.include?(:driving_license)),
        "原车发票" => present_text(items.include?(:original_vehicle_invoice)),
        "交强险" => present_text(items.include?(:compulsory_insurance)),
        "登记证" => present_text(items.include?(:registration_license)),
        "环保标记" => present_text(items.include?(:environment_mark)),
        "新车主身份证原件" => present_text(items.include?(:new_owner_idcard)),
        "车辆牌照" => present_text(items.include?(:original_license)),
        "购置税" => present_text(items.include?(:purchase_tax))
      }
    end

    def present_text(condition)
      condition ? "有" : "无"
    end

    # 公司ID
    def corpId
      object.company_id
    end

    # 公司名称
    def corpName
      object.company.name
    end
    alias attrCorpName corpName

    # 公司联系电话
    def corpPhone
      object.company.contact_mobile
    end

    # 公司联系人
    def corpContact
      object.company.contact
    end

    # 店名称
    def attrStoreName
      ""
    end
    alias stockLocateName attrStoreName

    # 销售底价
    def bottomPrice
      return if object.sales_minimun_price_cents.blank?

      "#{object.sales_minimun_price_wan}万元"
    end

    # 老车型标识
    def oldCatalogueTag
      "0"
    end

    # 车辆状态
    def maintainState
      return unless state.present?
      object.state_text
    end

    # 环保标准
    def environmentalLevel
      emission_standard_text
    end

    # 收购日期
    def buyDate
      Util::Formatter.to_date(acquired_at)
    end

    # 收购价格
    def buyPrice
      return if object.acquisition_price_cents.blank?

      "#{object.acquisition_price_wan}万元"
    end

    # 收购类型
    def buyKind
      acquisition_type_text
    end

    # 收购员工编码
    def buyStaffId
      acquirer_id
    end

    # 收购员工姓名
    def buyStaffName
      object.acquirer.name
    end

    # 收藏状态
    def collectState(_user_id)
      ""
    end

    # 商业险到期
    def commIssurValidDate
      Util::Formatter.to_month(object.acquisition_transfer.commercial_insurance_end_at)
    end

    # 里程单元
    def mileageUnit
      "公里"
    end

    # 收购渠道编码
    def infoSourceId
      channel_id
    end

    # 收购渠道名称
    def infoSourceName
      object.try(:channel).try(:name)
    end

    # 收购付款状态
    def payState
      ""
    end

    # 有无商业险
    def commIssurValidTag
      object.acquisition_transfer.items.include?(:commercial_insurance) ? "1" : "0"
    end

    def stockWarningColor
      ""
    end

    # 车身颜色
    def carColor
      object.exterior_color
    end

    # 内饰颜色
    def upholsteryColor
      object.interior_color
    end

    # 二维码
    def dimCodeUrl
      url = "#{ENV.fetch("SERVER_HOST")}/qrcode?content=" \
            "#{ENV.fetch("SERVER_HOST")}/api/v1/cars/#{object.id}/qrcode"

      URI.escape(url)
    end

    # 车架号
    def vinCode
      object.vin
    end

    # 排气量
    def outputVolumn
      object.displacement
    end

    # 档型名称
    def gearsType
      object.transmission_text
    end

    # 质保费用
    def warrantyFee
      return if object.warranty_fee_cents.blank?

      "#{object.warranty_fee_wan}万元"
    end

    # 车身类型名称
    def carType
      object.car_type_text
    end

    # 使用性质（0：非营运；1：营运；2：营转非；3：租赁）
    def usedType
      ""
    end

    # 质保类型（1:厂家质保；2:商家质保；0:无）
    def warrantyTag
      new_car_warranty_text
    end

    # 批发价格  暂无
    def wholeSalePrice
      nil
    end

    # 寄卖人
    def consignPerson
      consignor_name
    end

    # 寄卖人电话
    def consignTel
      consignor_phone
    end

    # 是否特卖
    def discTag
      ""
    end

    # 是否有OBD
    def obdTag
      "0"
    end

    # 手续联系人
    def procContacter
      object.acquisition_transfer.contact_man
    end

    # 可售标记
    def sellableTag
      sellable ? "1" : "0"
    end

    # 手续联系人电话
    def procContactTel
      object.acquisition_transfer.contact_mobile
    end

    # 是否共享
    def sharedTag
      "0"
    end

    def fuelType
      object.fuel_type
    end

    def stockPeriod
      stock_age_days.to_s
    end

    def stockState
      Car.state_in_stock.include?(object.state.to_sym) ? 1 : 2
    end

    def carState
      object.state
    end
  end
end
# rubocop:enable Style/MethodName,Metrics/ModuleLength
