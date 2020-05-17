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
#  is_special_offer               :boolean          default(FALSE)           # 是否特价
#  estimated_gross_profit_cents   :integer                                   # 预期毛利
#  estimated_gross_profit_rate    :float                                     # 预期毛利率
#  fee_detail                     :text                                      # 费用情况
#  current_publish_records_count  :integer          default(0), not null
#  images_count                   :integer          default(0)               # 图片数量
#  seller_id                      :integer                                   # 成交员工
#  cover_url                      :string                                    # 车辆封面图
#  alliance_cover_url             :string                                    # 联盟封面图
#  is_onsale                      :boolean          default(FALSE)           # 车辆是否特卖
#  onsale_price_cents             :integer                                   # 特卖价格
#  onsale_description             :string                                    # 特卖描述
#  owner_company_id               :integer                                   # 归属车商公司ID
#

# TODO: 类文件过大，需要拆分
class Car < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  extend EnumerizeWithGroups
  # includes ..................................................................
  include Priceable
  include AASM

  # relationships .............................................................
  belongs_to :company
  belongs_to :shop, -> { with_deleted }
  belongs_to :seller, -> { with_deleted },
             class_name: "User", foreign_key: :seller_id
  belongs_to :acquirer, -> { with_deleted },
             class_name: "User", foreign_key: :acquirer_id
  belongs_to :channel, -> { with_deleted }
  belongs_to :warranty, -> { with_deleted }
  belongs_to :owner_company

  def self.images_lambda(type)
    lambda do
      where(image_style: type).order(:sort)
                              .order(Image.location_order_sql.squish!)
                              .order(:id)
    end
  end

  # 车辆原图
  has_many :images, images_lambda(nil), as: :imageable, class_name: Image.name
  # 维保图片
  has_many :maintenance_images, images_lambda(:maintenance), as: :imageable, class_name: Image.name
  # 车辆的联盟图
  has_many :alliance_images, images_lambda("alliance"), as: :imageable, class_name: Image.name

  has_many :operation_records, -> { order("id desc") }, as: :targetable
  has_many :car_state_histories

  has_many :occurred_state_histories,
           -> { where("occurred_at <= ?", Time.zone.now).order(occurred_at: :asc, id: :asc) },
           class_name: CarStateHistory.name

  has_many :cooperation_company_relationships
  has_many :cooperation_companies,
           through: :cooperation_company_relationships,
           source: :cooperation_company
  has_many :car_price_histories
  has_many :transfer_records
  has_many :car_reservations do
    def to_histories
      where("id is not null").update_all(current: false)
    end
  end
  has_many :car_cancel_reservations
  has_many :stock_out_inventories do
    def to_histories
      where("id is not null").update_all(current: false)
    end
  end
  has_many :refund_inventories
  has_many :wechat_sharings

  # 车辆联盟展示
  has_many :all_alliances, -> { uniq }, through: :company, source: :alliances
  has_many :car_alliance_blacklists, dependent: :destroy

  has_many :alliances, class_name: "Alliance", through: :company, source: :alliances

  has_many :allied_companies, through: :company

  has_one :cover, -> { where(is_cover: true, image_style: nil) },
          class_name: "Image", as: :imageable

  has_one :alliance_cover, -> { where(is_cover: true, image_style: "alliance") },
          class_name: "Image", as: :imageable

  has_one :prepare_record
  has_one :car_dimension, class_name: "Dw::CarDimension"

  # 过户的信息都放在 TransferRecord 表中,
  # 通过 transfer_record_type 区分
  has_one :acquisition_transfer,
          -> { where(transfer_record_type: "acquisition") },
          class_name: "TransferRecord"
  has_one :sale_transfer,
          -> { where(transfer_record_type: "sale") },
          class_name: "TransferRecord"

  has_one :car_reservation, -> { where(current: true) }
  has_one :car_cancel_reservation, -> { where(current: true) }
  has_one :loan_bill, class_name: "EasyLoan::LoanBill"

  # 出库的信息都放在了 StockOutInventory 表中,
  # 通过 stock_out_inventory_type 区分
  has_one :sale_record,
          -> { where(current: true, stock_out_inventory_type: "sold") },
          class_name: "StockOutInventory"
  has_one :acquisition_refund_record,
          -> { where(current: true, stock_out_inventory_type: "acquisition_refunded") },
          class_name: "StockOutInventory"
  has_one :driven_back_record,
          -> { where(current: true, stock_out_inventory_type: "driven_back") },
          class_name: "StockOutInventory"
  has_one :stock_out_inventory, -> { where(current: true) }
  has_one :refund_inventory, -> { where(current: true) }

  # 联盟出库记录
  has_many :alliance_stock_out_inventories, foreign_key: :from_car_id
  has_one :alliance_stock_out_inventory, -> { where(current: true) }, foreign_key: :from_car_id
  # 联盟入库记录
  has_one :alliance_stock_in_inventory,
          -> { where(current: true) },
          class_name: "AllianceStockOutInventory",
          foreign_key: "to_car_id"

  has_one :che168_publish_record
  has_many :car_publish_records, class_name: "PublishCar::CarPublishRecord"

  has_one :publish_yiche_record,
          -> { where(current: true) },
          class_name: "PublishCar::YicheRecord"
  has_one :publish_che168_record,
          -> { where(current: true) },
          class_name: "PublishCar::Che168Record"
  has_one :publish_com58_record,
          -> { where(current: true) },
          class_name: "PublishCar::Com58Record"

  has_many :maintenance_records, dependent: :nullify
  has_many :ant_queen_records, dependent: :nullify

  has_one :finance_car_income, class_name: "Finance::CarIncome", dependent: :destroy
  has_many :finance_car_fees, class_name: "Finance::CarFee", dependent: :destroy

  has_one :detection_report
  # validations ...............................................................
  validates :name, :series_name, :acquirer_id, :shop_id,
            :acquired_at, :acquisition_type, :license_info,
            presence: true

  validates :stock_number,
            uniqueness_without_deleted: { scope: :company_id },
            if: :stock_number?
  # 出库日期不能早于入库日期
  validate :stock_dates

  # callbacks .................................................................
  before_validation(on: :create) do
    self.name = make_system_name if name.blank?
  end

  before_save :generate_stock_number, unless: :stock_number?
  before_save :set_ages, :set_estimated_gross_profit
  before_save :set_name_pinyin
  before_save :syncs_shop_id
  before_save :clean_licensed_at
  before_save :ensure_acquisition_price
  before_save :upcase_vin
  before_validation :set_system_name
  after_save :notify_market_erp
  after_save :set_cover_url
  after_commit do
    EtlCarWorker.perform_async(id)
  end

  # scopes ....................................................................
  scope :eager_load_bunch_data, proc {
    includes(
      :cover, :sale_transfer, :images, :acquirer, :shop,
      { stock_out_inventory: :seller },
      { acquisition_transfer: :images },
      prepare_record: :prepare_items
    )
  }

  # for 联盟后台, 以入库操作日期为查询条件
  scope :stock_in_on,
        lambda { |date|
          joins(:transfer_records)
            .where("transfer_records.transfer_record_type = ?", "acquisition")
            .where("transfer_records.created_at between ? and ?",
                   Util::Date.parse_date_string(date).beginning_of_day,
                   Util::Date.parse_date_string(date).end_of_day)
        }
  # for 联盟后台, 以出库操作日期为查询条件
  scope :stock_out_on,
        lambda { |date|
          joins(:stock_out_inventory)
            .where("stock_out_inventories.created_at between ? and ?",
                   Util::Date.parse_date_string(date).beginning_of_day,
                   Util::Date.parse_date_string(date).end_of_day)
        }

  # for 联盟后台
  scope :reserved_on,
        lambda { |date|
          where("cars.reserved_at between ? and ?",
                Util::Date.parse_date_string(date).beginning_of_day,
                Util::Date.parse_date_string(date).end_of_day)
        }

  scope :show_price_wan_gt,
        ->(price) { where("cars.show_price_cents > ?", price.to_i * 100 * 100_00) }
  scope :show_price_wan_lt,
        ->(price) { where("cars.show_price_cents < ?", price.to_i * 100 * 100_00) }

  scope :acquired_between,
        lambda { |begin_time, end_time|
          where("acquired_at >= ? AND acquired_at <= ?", begin_time, end_time)
        }

  scope :stock_out_between,
        lambda { |begin_time, end_time|
          where("stock_out_at >= ? AND stock_out_at <= ?", begin_time, end_time)
        }

  scope :stock_by_month,
        lambda { |begin_time, end_time|
          sql = <<-SQL.squish!
            (cars.acquired_at >= :begin_time AND cars.acquired_at <= :end_time)
            OR
            (
              cars.acquired_at < :begin_time AND
              (cars.stock_out_at IS NULL OR cars.stock_out_at >= :begin_time)
            )
          SQL

          where(sql, begin_time: begin_time, end_time: end_time)
        }

  scope :sold_or_driven_back_at_by_seller_id_eq,
        lambda { |seller_id|
          sql = <<-SQL.squish!
            (
              stock_out_inventories.stock_out_inventory_type = 'sold'
              AND stock_out_inventories.seller_id = :seller_id
            ) OR (
              stock_out_inventories.stock_out_inventory_type = 'acquisition_refunded'
              AND cars.acquirer_id = :seller_id
            )
          SQL

          joins(:stock_out_inventory).where(sql, seller_id: seller_id)
        }

  scope :in_stock_by_time,
        lambda { |time|
          sql = <<-SQL.squish!
            cars.acquired_at <= :time
            AND
            (cars.stock_out_at IS NULL OR cars.stock_out_at > :time)
          SQL

          where(sql, time: time)
        }

  scope :similar,
        lambda { |brand_name, series_name, show_price_cents|
          show_price_cents = show_price_cents.to_i
          minimum_show_price_cents = (show_price_cents * 0.75).to_i
          maximum_show_price_cents = (show_price_cents * 1.25).to_i

          match_brand_and_series = <<-SQL.squish!
            cars.brand_name = '#{brand_name}' AND cars.series_name = '#{series_name}'
          SQL
          match_prices = <<-SQL.squish!
            cars.show_price_cents >= '#{minimum_show_price_cents}' AND
            cars.show_price_cents <= '#{maximum_show_price_cents}'
          SQL
          match_brand_and_prices = <<-SQL.squish!
            cars.brand_name = '#{brand_name}' AND #{match_prices}
          SQL

          condition_sql = [
            match_brand_and_series, match_brand_and_prices, match_prices
          ].map { |sql| "(#{sql})" }.join(" OR ")

          similar_sort_column = <<-SQL.squish!
            (
              CASE
              WHEN #{match_brand_and_series} THEN 0
              WHEN #{match_brand_and_prices} THEN 1
              WHEN #{match_prices} THEN 2
              END
            ) AS similar_sort_column
          SQL

          price_reference = <<-SQL.squish!
            abs(cars.show_price_cents - '#{show_price_cents}') AS price_reference
          SQL

          select("cars.*, #{similar_sort_column}, #{price_reference}")
            .where(condition_sql)
            .order("similar_sort_column, price_reference ASC NULLS LAST")
        }

  # additional config .........................................................
  ransacker :stock_out_at do
    Arel.sql("date(cars.stock_out_at AT TIME ZONE 'GMT+8')")
  end

  ransacker :name do
    Arel.sql("CONCAT(cars.name, ' ', cars.brand_name, ' ', cars.system_name)")
  end

  alias_attribute :actual_states_statistic, :states_statistic

  acts_as_paranoid
  has_shortened_urls

  serialize :manufacturer_configuration, ActiveRecord::Coders::NestedHstore

  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :alliance_images, allow_destroy: true
  accepts_nested_attributes_for :maintenance_images, allow_destroy: true
  accepts_nested_attributes_for :cooperation_company_relationships,
                                allow_destroy: true
  accepts_nested_attributes_for :acquisition_transfer
  accepts_nested_attributes_for :sale_transfer

  accepts_nested_attributes_for :prepare_record

  price_wan :acquisition_price, :show_price, :online_price,
            :sales_minimun_price, :manager_price, :alliance_minimun_price,
            :new_car_guide_price, :new_car_additional_price,
            :new_car_final_price, :consignor_price, :closing_cost,
            :onsale_price

  priceable :estimated_gross_profit, unit: :wan, monetize_options: { allow_nil: true }

  # TODO: 未来做退车回库, 需要注意成交价
  price_yuan :warranty_fee, :acquisition_price

  # 收购, 寄卖, 合作, 置换, 联盟入库
  enumerize :acquisition_type,
            in: %i(acquisition consignment cooperation permute alliance)
  # 微型车 小型车 紧凑型 中型车 中大型车 大型车 MPV SUV 跑车 皮卡 微面 电动车
  enumerize :car_type,
            in: %i(
              micro_car small_car compact_car mid_size_car mid_full_size_car full_size_car
              mpv suv sports_car pickup_trucks small_van electrocar
            )

  enumerize :attachments,
            multiple: true,
            in: %i(
              vehicle_tools first_aid_kit spare_tire tripod instructions
              antenna key cigarette_lighter maintenance_manual fire_extinguisher
              ashtray navigation_card
            )

  enumerize :fuel_type, in: %i(gasoline diesel electric hybrid other)
  enumerize :transmission, in: %i(manual auto manual_automatic other dsg cvt)
  enumerize :emission_standard, in: %i(guo_1 guo_2 guo_3 guo_4 guo_5 eu_1 eu_2 eu_3 eu_4 eu_5)
  enumerize :license_info, in: %i(licensed unlicensed new_car), predicates: true
  enumerize :new_car_warranty, in: %i(manufacturer seller none)
  enumerize :state,
            in: %i(
              in_hall preparing shipping loaning transferred
              driven_back sold acquisition_refunded alliance_stocked_out alliance_refunded
            ),
            groups: {
              in_stock: %i(in_hall preparing shipping loaning transferred),
              out_of_stock: %i(driven_back sold acquisition_refunded
                               alliance_stocked_out alliance_refunded),
              finished: %i(sold acquisition_refunded alliance_refunded)
            }

  aasm column: "state" do
    # 在厅
    state :in_hall, initial: true
    # 整备
    state :preparing
    # 在途
    state :shipping
    # 转场
    state :transferred
    # 外借
    state :loaning

    # 车主开回
    state :driven_back, before_enter: [:remove_reserved]
    # 销售出库
    state :sold, before_enter: [:remove_reserved]
    # 收购退车
    state :acquisition_refunded, before_enter: [:remove_reserved]
    # 联盟出库
    state :alliance_stocked_out, before_enter: [:remove_reserved]
    # 联盟退车(复制出来的新车才有这个状态)
    state :alliance_refunded, before_enter: [:remove_reserved]

    # 销售出库
    event :sell do
      transitions to: :sold
    end

    # 收购退车
    event :acquisition_refund do
      transitions to: :acquisition_refunded
    end

    # 车主开回
    event :drive_back do
      transitions to: :driven_back
    end

    # 回库
    event :return_to_hall, after: :clear_stock_out_inventories! do
      transitions from: [:driven_back, :acquisition_refunded, :sold],
                  to: :in_hall
    end

    # 联盟出库, 这里修改的是原车状态. 只有在库状态才能出库
    event :alliance_stock_out do
      transitions from: [:in_hall, :preparing, :shipping, :loaning, :transferred],
                  to: :alliance_stocked_out
    end

    # 联盟回库, 这里修改的是原车状态, 需要将原车的联盟出库记录清空
    event :alliance_stock_back, after: :clear_alliance_stock_out_inventories! do
      transitions from: :alliance_stocked_out,
                  to: :in_hall
    end

    # 联盟退车, 这里修改的是新车(复制到出库公司的车)状态. 只有联盟出库的在库车辆才能退车
    event :alliance_refund do
      transitions from: [:in_hall, :preparing, :shipping, :loaning, :transferred],
                  to: :alliance_refunded do
                    guard do
                      acquired_from_alliance?
                    end
                  end
    end
  end

  delegate :name, to: :owner_company, prefix: true, allow_nil: true

  # class methods .............................................................

  def self.ransackable_scopes(_auth_object = nil)
    %i(show_price_wan_gt show_price_wan_lt sold_or_driven_back_at_by_seller_id_eq
       stock_in_on stock_out_on reserved_on)
  end

  # public instance methods ...................................................

  def find_or_create_stock_out_inventory
    return stock_out_inventory if stock_out_inventory.present?

    StockOutInventory.create(car_id: id, shop_id: shop_id, current: true)
  end

  def find_or_init_stock_out_inventory
    stock_out_inventory || stock_out_inventories.new(shop_id: shop_id)
  end

  def count_states_statistic
    histories = occurred_state_histories.to_a

    return { state => count_stock_age_days } if histories.empty?

    current_history = histories.last
    statistic = count_history_states!(histories)

    count_current_states!(current_history, statistic).reject { |_k, v| v <= 0 }
  end

  def make_system_name
    sanitized_brand_name = if series_name.blank?
                             brand_name
                           elsif series_name.start_with?(brand_name)
                             ""
                           else
                             brand_name
                           end

    [sanitized_brand_name, series_name, style_name].reject(&:blank?).join(" ")
  end

  def manufacturer_configuration
    configurations = self[:manufacturer_configuration]
    if configurations.nil? || configurations.empty?
      configurations = []

      default_fields.each do |param, fields|
        field_group = { "name" => param, "fields" => [] }

        fields.each do |field, type|
          the_field = { "name" => field, "value" => "", "type" => type }
          field_group["fields"] << the_field
        end

        configurations << field_group
      end
    end

    configurations
  end

  def reserved_days
    return unless reserved_at

    end_date = if Car.state_finished.include?(state.to_sym) && stock_out_inventory
                 stock_out_inventory.completed_at || stock_out_inventory.refunded_at
               else
                 Time.zone.now
               end

    Util::Date.date_different(end_date, reserved_at)
  end

  def displacement_text
    return "" unless displacement.present?

    format("%.1f%s", displacement.to_f, displacement_unit)
  end

  def displacement_unit
    is_turbo_charger ? "T" : "L"
  end

  def manufacturer_configuration_hash
    return {} unless manufacturer_configuration.present?

    {}.tap do |hash|
      manufacturer_configuration.each do |type|
        hash[type["name"]] = {}.tap do |sub_hash|
          type["fields"].each do |e|
            sub_hash[e["name"]] = e["value"]
          end
        end
      end
    end
  end

  def notify_market_erp
    return unless Rails.env.production?

    Sidekiq::ScheduledSet.new.each do |retri|
      retri.delete if retri.klass == "MarketERPNoticeWorker" && retri.args == [id]
    end

    MarketERPNoticeWorker.perform_in(10.seconds, id)
  end

  def viewed_count
    @_viewed_count ||= Car::ViewedCountService.show(id)
  end

  def current_publish_records
    car_publish_records.where(current: true)
  end

  def sync_state_text
    if current_publish_records_count == 0
      "无同步"
    else
      "同步#{current_publish_records_count}"
    end
  end

  # 车辆联盟展示
  def allowed_alliances
    all_alliances.where.not(id: car_alliance_blacklists.pluck(:alliance_id))
  end

  # 修改展示联盟
  def allowed_alliances=(new_alliances)
    old_blacklist = all_alliances.pluck(:id) - allowed_alliances.pluck(:id)
    new_blacklist = all_alliances.pluck(:id) - new_alliances

    if old_blacklist != new_blacklist
      CarAllianceBlacklist.where(car_id: id)
                          .where(alliance_id: old_blacklist)
                          .delete_all

      CarAllianceBlacklist.transaction do
        new_blacklist.each do |item|
          CarAllianceBlacklist.create!(car_id: id, alliance_id: item)
        end
      end
    end
  end

  # 成本合计
  def cost_sum
    acquisition_price_yuan.to_i +
      prepare_record.try(:total_amount_yuan).to_i +
      acquisition_transfer.try(:total_transfer_fee_yuan).to_i
  end

  def cost_sum_wan
    (cost_sum.to_f / 10000).round(2)
  end

  # 已入库车辆创建财务记录
  def find_or_create_finance_car_income
    return finance_car_income if finance_car_income
    Finance::CarIncome.create!(
      car_id: id,
      company_id: company_id,
      acquisition_price_wan: acquisition_price_wan,
      prepare_cost_yuan: prepare_record.try(:total_amount_yuan),
      closing_cost_wan: try(:closing_cost_wan)
    )
  end

  # protected instance methods ................................................
  def reload
    remove_instance_variable(:@_viewed_count) if defined?(@_viewed_count)

    super
  end

  def allied?(current_user)
    company_id != current_user.company_id
  end

  def in_same_own_brand_alliance?(current_user)
    AllianceCompanyRelationship.where(
      alliance_id: allowed_alliances.own_brand.pluck(:id),
      company_id: current_user.company_id
    ).exists?
  end

  def set_cover_url
    if cover.present?
      update_columns(cover_url: cover.url)
    else
      update_columns(cover_url: nil)
    end

    if alliance_cover.present?
      update_columns(alliance_cover_url: alliance_cover.url)
    else
      update_columns(alliance_cover_url: nil)
    end
  end

  def acquired_from_alliance?
    acquisition_type == "alliance"
  end

  def valuable_acquisition_price_wan
    acquisition_price_wan if acquisition_price_wan > 0.1
  end

  # private instance methods ..................................................

  private

  def syncs_shop_id
    return unless new_record? || shop_id_changed?

    transfer_records.update_all(shop_id: shop_id)
    car_reservations.update_all(shop_id: shop_id)
    prepare_record.update(shop_id: shop_id) if prepare_record.present?
    stock_out_inventories.update_all(shop_id: shop_id)
  end

  def clear_stock_out_inventories!
    update_columns(stock_out_at: nil, closing_cost_cents: nil)
    stock_out_inventories.to_histories
  end

  def clear_alliance_stock_out_inventories!
    update_columns(stock_out_at: nil, closing_cost_cents: nil)
    alliance_stock_out_inventories.to_histories
  end

  def remove_reserved
    self.reserved = false
  end

  def set_ages
    self.age = count_age

    end_time = stock_out_at.blank? ? Time.zone.now : stock_out_at
    self.stock_age_days = count_stock_age_days(end_time)

    return if in_state_finished?

    self.states_statistic = count_states_statistic
  end

  def set_name_pinyin
    columns = [brand_name, series_name, style_name]

    self.name_pinyin = columns.select(&:present?)
                              .map { |s| Util::Brand.to_pinyin(s) }.join(" ")
  end

  def count_stock_age_days(end_time = Time.zone.now)
    acquired_at ? Util::Date.date_different(end_time, acquired_at) : 0
  end

  def count_age
    return 0 unless licensed?

    licensed_at ? Util::Date.date_different(Time.zone.now, licensed_at) : 0
  end

  # 生成库存编号
  def generate_stock_number
    if company.automated_stock_number
      generate_stock_number_from_settings
    else
      generate_stock_number_by_system
    end
  end

  # 根据商家的设置来生成
  def generate_stock_number_from_settings
    last_car = company.cars
                      .where("stock_number like ?", "#{company.automated_stock_number_prefix}%")
                      .last

    if last_car
      number = last_car.stock_number
                       .sub(/\A#{company.automated_stock_number_prefix}/, "").to_i.abs + 1
    else
      number = company.automated_stock_number_start.abs
    end
    self.stock_number = company.automated_stock_number_prefix + number.to_s
  end

  # 系统自动生成
  def generate_stock_number_by_system
    # 如果没有车架号, 或者不需要按vin生成库存号
    return generate_stock_number_default unless
      company.stock_number_by_vin? && vin.present?

    intended_stock_number = vin.last(6)

    # 如果库存号冲突, 退回默认策略
    if company.cars.exists?(stock_number: intended_stock_number)
      generate_stock_number_default
    else
      self.stock_number = intended_stock_number
    end
  end

  def generate_stock_number_default
    last_car = company.cars.where("stock_number like ?", "CLK%").last

    number = if last_car
               last_car.stock_number.sub(/\ACLK/, "").to_i + 1
             else
               1
             end
    self.stock_number = "CLK" + number.to_s
  end

  def acquisition_or_permute?
    %w(acquisition permute).include?(acquisition_type)
  end

  def consignment?
    acquisition_type == "consignment"
  end

  def count_history_states!(histories)
    histories.each_with_index.inject({}) do |result, (history, index)|
      result.tap do |hash|
        if index == 0
          hash[history.previous_state] = Util::Date.date_different(
            history.occurred_at, acquired_at
          )
        else
          days = Util::Date.date_different(
            history.occurred_at, histories[index - 1].occurred_at
          )

          hash[history.previous_state] = hash.fetch(history.previous_state, 0) + days
        end
      end
    end
  end

  def count_current_states!(current_history, statistic)
    statistic.tap do |hash|
      days = Util::Date.date_different(Time.zone.now, current_history.occurred_at)

      hash[current_history.state] = hash.fetch(current_history.state, 0) + days
    end
  end

  def default_fields
    @default_fields ||= YAML
                        .load_file("#{Rails.root}/config/manufacturer_configuration.yml")
                        .with_indifferent_access[:default]
  end

  def set_system_name
    self.system_name = make_system_name
  end

  def clean_licensed_at
    return if licensed?

    self.licensed_at = nil
  end

  def set_estimated_gross_profit
    minimum_sale_price = find_minimum_sale_price

    self.estimated_gross_profit_cents = count_estimated_gross_profit(minimum_sale_price)
    self.estimated_gross_profit_rate = count_estimated_gross_profit_rate(
      estimated_gross_profit_cents, minimum_sale_price
    )
  end

  def count_estimated_gross_profit(minimum_sale_price)
    return 0 if acquisition_type.consignment? # 寄卖车辆预计毛利为0

    minimum_sale_price - acquisition_price_cents.to_i
  end

  def count_estimated_gross_profit_rate(estimated_gross_profit_cents, minimum_sale_price)
    return 0 if minimum_sale_price <= 0

    (estimated_gross_profit_cents.to_f / minimum_sale_price).round(2)
  end

  def find_minimum_sale_price
    [
      show_price_cents,
      online_price_cents,
      sales_minimun_price_cents,
      manager_price_cents,
      alliance_minimun_price_cents
    ].select { |price| price.to_i > 0 }.min.to_i
  end

  def stock_dates
    errors.add(:stock_out_at, "不能早于收购日期") if stock_out_at.present? && stock_out_at < acquired_at
  end

  def ensure_acquisition_price
    self.acquisition_price_cents ||= 0
  end

  def upcase_vin
    vin.try(:upcase!)
  end
end
