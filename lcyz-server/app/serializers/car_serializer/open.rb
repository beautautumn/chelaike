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
  class Open < ActiveModel::Serializer
    attributes :id, :company_id, :shop_id, :cover_url,
               :alliance_cover_url, :vin, :stock_number,
               :brand_name, :manufacturer_name, :series_name, :style_name, :name,
               :car_type_text, :door_count, :displacement_text, :fuel_type,
               :is_turbo_charger, :transmission, :exterior_color,
               :interior_color, :mileage, :mileage_in_fact,
               :emission_standard_text, :license_info, :licensed_at,
               :manufactured_at, :show_price_wan, :online_price_wan,
               :new_car_guide_price_wan, :new_car_additional_price_wan,
               :new_car_discount, :new_car_final_price_wan, :star_rating,
               :warranty_fee_yuan, :is_fixed_price,
               :allowed_mortgage, :mortgage_note, :selling_point,
               :maintain_mileage, :has_maintain_history,
               :new_car_warranty, :created_at, :age, :sellable, :system_name,
               :presell, :is_special_offer, :attachments, :similar_cars_count,
               :is_onsale, :onsale_price_wan, :onsale_description, :reserved,
               :state

    has_one :acquisition_transfer, serializer: TransferRecordSerializer::OpenAcquisition
    belongs_to :company, serializer: CompanySerializer::Mini
    belongs_to :shop, serializer: ShopSerializer::Common

    def cover_url
      alliance_company = instance_options[:alliance_company]
      url = object.cover_url

      # 显示联盟图片，如果没有，显示原图
      if alliance_company.present? && object.alliance_cover_url.present?
        object.alliance_cover_url
      else
        url
      end
    end

    def presell
      object.show_price_cents.blank? && object.cover_url.present?
    end

    def similar_cars_count
      0
    end
  end
end
