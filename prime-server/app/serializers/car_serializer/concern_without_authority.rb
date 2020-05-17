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
  module ConcernWithoutAuthority
    extend ActiveSupport::Concern

    included do
      attributes :id, :company_id, :acquirer_id, :acquired_at, :shop_id,
                 :channel_id, :acquisition_type, :cover_url,
                 :stock_number, :vin, :state, :state_text, :state_note, :brand_name,
                 :manufacturer_name, :series_name, :style_name, :name, :car_type,
                 :door_count, :displacement, :fuel_type, :is_turbo_charger,
                 :transmission, :exterior_color, :interior_color, :mileage,
                 :mileage_in_fact, :level, :emission_standard, :license_info,
                 :licensed_at, :manufactured_at, :show_price_wan, :show_price_cents,
                 :online_price_wan, :online_price_cents,
                 :new_car_guide_price_wan, :new_car_guide_price_cents,
                 :new_car_additional_price_wan, :new_car_additional_price_cents,
                 :new_car_discount,
                 :new_car_final_price_wan, :new_car_final_price_cents,
                 :interior_note, :star_rating, :warranty_id,
                 :warranty_fee_yuan, :warranty_fee_cents,
                 :is_fixed_price, :allowed_mortgage, :mortgage_note,
                 :selling_point, :maintain_mileage, :has_maintain_history, :red_stock_warning_days,
                 :new_car_warranty, :created_at, :updated_at, :age, :sellable, :actual_states_statistic,
                 :yellow_stock_warning_days, :state_changed_at, :reserved_at, :reserved,
                 :reserved_days, :consignor_name, :consignor_phone,
                 :consignor_price_wan, :consignor_price_cents,
                 :stock_out_at, :closing_cost_wan, :closing_cost_cents,
                 :predicted_restocked_at,
                 :current_plate_number, :deleted_at, :system_name, :stock_age_days,
                 :is_special_offer, :fee_detail, :cost_sum, :cost_statement,
                 :is_onsale, :onsale_price_wan, :onsale_price_cents,
                 :onsale_description, :estimate_price_wan, :estimate_price_cents,
                 :loan_status, :loan_status_show_text, :loan_bill_id,
                 :acquisition_price_wan, :acquisition_price_cents,
                 :alliance_minimun_price_wan, :alliance_minimun_price_cents,
                 :sales_minimun_price_wan, :sales_minimun_price_cents,
                 :manager_price_wan, :manager_price_cents
    end

    def displacement
      object.displacement.try(:to_s)
    end

    # 成本详情
    def cost_statement
      {
        acquisition_price: {
          name: "收购价",
          value: object.acquisition_price_wan,
          unit: "万元"
        },
        prepare_fee: {
          name: "整备费用",
          value: object.prepare_record.try(:total_amount_yuan),
          unit: "元"
        },
        license_transfer_fee: {
          name: "牌证过户费用",
          value: object.acquisition_transfer.try(:total_transfer_fee_yuan),
          unit: "元"
        }
      }
    end

    # 成本合计
    def cost_sum
      {
        name: "成本",
        value: object.cost_sum_wan,
        unit: "万元"
      }
    end
  end
end
