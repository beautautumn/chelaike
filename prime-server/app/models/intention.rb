# == Schema Information
#
# Table name: intentions # 意向
#
#  id                            :integer          not null, primary key     # 意向
#  customer_id                   :integer                                    # 客户ID
#  customer_name                 :string                                     # 客户姓名
#  intention_type                :string                                     # 意向类型
#  creator_id                    :integer                                    # 意向创建者
#  assignee_id                   :integer                                    # 分配员工ID
#  province                      :string                                     # 省份
#  city                          :string                                     # 城市
#  intention_level_id            :integer                                    # 意向级别ID
#  channel_id                    :integer                                    # 客户渠道
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  company_id                    :integer                                    # 公司ID
#  shop_id                       :integer                                    # 店ID
#  customer_phones               :string           default([]), is an Array  # 客户联系方式
#  state                         :string           default("pending")        # 跟进状态
#  customer_phone                :string                                     # 客户电话
#  intention_note                :text                                       # 意向描述
#  gender                        :string                                     # 性别
#  brand_name                    :string                                     # 出售车辆品牌名称
#  series_name                   :string                                     # 出售车辆车系名称
#  color                         :string                                     # 颜色
#  mileage                       :float                                      # 里程(万公里)
#  licensed_at                   :date                                       # 上牌日期
#  minimum_price_cents           :integer                                    # 最低价格
#  maximum_price_cents           :integer                                    # 最高价格
#  estimated_price_cents         :integer                                    # 评估车价
#  seeking_cars                  :jsonb            is an Array               # 求购车辆
#  style_name                    :string                                     # 出售车辆车款名称
#  interviewed_time              :datetime                                   # 预约时间
#  processing_time               :datetime                                   # 跟进时间
#  checked_count                 :integer          default(0)                # 到店/评估次数
#  consigned_at                  :date                                       # 寄卖时间
#  deleted_at                    :datetime                                   # 删除时间
#  source                        :string           default("user_operation") # 意向产生来源
#  import_task_id                :integer                                    # 意向导入记录ID
#  source_car_id                 :integer                                    # 来源车辆ID
#  source_company_id             :integer                                    # 来源公司ID
#  deposit_cents                 :integer                                    # 定金
#  closing_cost_cents            :integer                                    # 成交价格
#  closing_car_id                :integer                                    # 成交车辆ID
#  closing_car_name              :string                                     # 成交车辆名称
#  creator_type                  :string                                     # 意向创建者多态
#  alliance_company_id           :integer
#  alliance_assignee_id          :integer                                    # 联盟用户ID
#  earnest                       :boolean          default(FALSE)            # 是否已收意向金
#  alliance_assigned_at          :datetime                                   # 分配给车商的时间
#  in_shop_at                    :datetime                                   # 客户到店时间
#  alliance_state                :string                                     # 联盟意向状态
#  alliance_intention_level_id   :integer
#  annual_inspection_notify_date :date                                       # 年审到期提醒日期
#  insurance_notify_date         :date                                       # 保险到期提醒日期
#  mortgage_notify_date          :date                                       # 按揭到期提醒日期
#  after_sale_assignee_id        :integer                                    # 服务归属人ID
#

class Intention < ActiveRecord::Base
  SeekingCar = Struct.new(:brand_name, :series_name, :minimum_price_wan, :maximum_price_wan) do
    def to_sql
      sql = [:brand_name, :series_name].map do |key|
        value = send key

        value.present? ? "cars.#{key} = '#{value}'" : next
      end.compact.join(" AND ")

      sql.present? ? "(#{sql})" : nil
    end
  end

  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  extend EnumerizeWithGroups
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :customer
  belongs_to :creator, foreign_key: :creator_id, polymorphic: true
  belongs_to :assignee, -> { with_deleted },
             class_name: "User",
             foreign_key: :assignee_id, touch: true
  belongs_to :alliance_assignee, -> { with_deleted },
             class_name: "AllianceCompany::User",
             foreign_key: :alliance_assignee_id, touch: true

  belongs_to :after_sale_assignee, -> { with_deleted },
             class_name: "User",
             foreign_key: :after_sale_assignee_id, touch: true

  belongs_to :intention_level
  belongs_to :channel, -> { with_deleted }
  belongs_to :company
  belongs_to :shop
  belongs_to :import_task
  belongs_to :source_car, class_name: "Car", foreign_key: :source_car_id
  belongs_to :source_company, class_name: "Company", foreign_key: :source_company_id
  belongs_to :closing_car, class_name: "Car", foreign_key: :closing_car_id

  has_one :latest_intention_push_history,
          -> { order(id: :desc).limit(1) },
          class_name: "IntentionPushHistory"

  has_many :intention_push_histories, -> { order(id: :desc) }
  has_many :intention_push_cars
  has_many :cars, through: :intention_push_cars, source: :car
  has_many :operation_records, -> { order("id desc") }, as: :targetable
  has_many :intention_shared_users, foreign_key: :intention_id

  has_many :shared_users, through: :intention_shared_users, source: :user

  has_one :intention_appointment_car

  # validations ...............................................................
  validates :customer_id, presence: true
  validate :company_presence
  validates :intention_type, presence: true
  # callbacks .................................................................
  before_save :init_processing_time
  before_save :set_creator_type
  # scopes ....................................................................
  scope :with_customer, -> { where("intentions.customer_id IS NOT NULL") }

  scope :eager_load_bunch_data, proc {
    includes(
      :assignee, :intention_level, :channel,
      intention_push_histories: [
        :executor, cars: [
          :cover, :sale_transfer, :images, :acquirer, :shop,
          { stock_out_inventory: :seller },
          { acquisition_transfer: :images },
          prepare_record: :prepare_items
        ]
      ]
    )
  }

  scope :phones_include, lambda { |phones|
    sql = <<-SQL
      EXISTS (
        SELECT *
          FROM unnest(customers.phones) p(phone)
          WHERE phone in (:phones)
      )
      OR EXISTS (
        SELECT *
          FROM unnest(intentions.customer_phones) p(customer_phone)
          WHERE customer_phone in (:phones)
      )
      OR customers.phone in (:phones)
      OR intentions.customer_phone in (:phones)
    SQL

    with_customer
      .joins("LEFT JOIN customers ON customers.id = intentions.customer_id")
      .where(sql.squish!, phones: phones)
  }

  scope :keyword, lambda { |k|
    sql = <<-SQL
      EXISTS (
        SELECT *
          FROM unnest(intentions.customer_phones) p(phone)
          WHERE phone LIKE :keyword
      )
      OR intentions.customer_phone LIKE :keyword
      OR intentions.customer_name LIKE :keyword
      OR intentions.intention_note LIKE :keyword
      OR intentions.brand_name LIKE :keyword
      OR intentions.series_name LIKE :keyword
      OR
        EXISTS (
          SELECT *
            FROM unnest(intentions.seeking_cars) c(car)
            WHERE
              car->>'brand_name' LIKE :keyword
              OR car->>'series_name' LIKE :keyword
        )
    SQL

    with_customer.where(sql.squish!, keyword: "%#{k}%")
  }

  scope :pending_dealing, lambda {
    now = Time.zone.now
    end_of_day = now.end_of_day

    sql = <<-SQL.squish!
      intentions.state = 'pending'
      OR intentions.state = 'processing' and intentions.processing_time < (:end_of_day)
      OR intentions.state = 'interviewed' and intentions.interviewed_time < (:now)
    SQL
    with_customer.where(sql, now: now, end_of_day: end_of_day)
  }

  scope :pending_dealing_today, lambda {
    now = Time.zone.now
    beginning_of_day = now.beginning_of_day
    end_of_day = now.end_of_day

    sql = <<-SQL.squish!
      (intentions.state = 'processing'
      AND intentions.processing_time >= :beginning_of_day
      AND intentions.processing_time <= :end_of_day)
      OR
      (intentions.state = 'interviewed'
      AND intentions.interviewed_time >= :now
      AND intentions.interviewed_time <= :end_of_day)
    SQL
    with_customer.where(sql, now: now, beginning_of_day: beginning_of_day, end_of_day: end_of_day)
  }

  scope :expired_dealing, lambda {
    now = Time.zone.now
    beginning_of_day = now.beginning_of_day

    sql = <<-SQL.squish!
      (intentions.state = 'processing'
      AND intentions.processing_time < :beginning_of_day)
      OR
      (intentions.state = 'interviewed'
      AND intentions.interviewed_time < :now)
    SQL
    with_customer.where(sql, now: now, beginning_of_day: beginning_of_day)
  }

  scope :pending_interviewing, lambda { |begin_time, end_time|
    with_customer.where(state: "interviewed").where(
      "intentions.interviewed_time >= ? AND intentions.interviewed_time <= ?",
      begin_time, end_time
    )
  }

  scope :pending_processing, lambda { |begin_time, end_time|
    sql = <<-SQL.squish!
      intentions.state = 'processing'
      AND intentions.processing_time >= :begin_time
      AND intentions.processing_time <= :end_time
    SQL

    with_customer.where(sql, begin_time: begin_time, end_time: end_time)
  }

  scope :expired_interviewed, lambda { |time|
    with_customer.where(state: "interviewed").where("intentions.interviewed_time < ?", time)
  }

  scope :expired_processed, lambda { |time|
    with_customer.where(state: "processing").where("intentions.processing_time < ?", time)
  }

  scope :pending_interviewing_task_today, lambda {
    pending_interviewing(
      Time.zone.now, Time.zone.now.end_of_day
    )
  }

  scope :pending_processing_task_today, lambda {
    pending_processing(
      Time.zone.now.beginning_of_day,
      Time.zone.now.end_of_day
    )
  }

  scope :expired_interviewed_task_today, lambda {
    expired_interviewed(Time.zone.now)
  }

  scope :expired_processed_task_today, lambda {
    expired_processed(Time.zone.now.beginning_of_day)
  }

  scope :overstep, lambda { |user_ids|
    joins(:assignee)
      .where("intentions.assignee_id in (:ids) OR users.manager_id in (:ids)", ids: user_ids)
  }

  scope :due_time_filter, lambda { |operation|
    where(
      <<-SQL.squish!
        COALESCE(
          intentions.processing_time,
          intentions.interviewed_time,
          intentions.created_at
        ) #{operation} current_timestamp
      SQL
    )
  }

  scope :expired, -> { due_time_filter("<") }
  scope :unexpired, -> { due_time_filter(">=") }

  scope :to_be_recycled, lambda { |recovery_time|
    sql = <<-SQL.squish!
      intentions.state = 'failed'
      OR intentions.state = 'invalid'
      OR intentions.state = 'processing' AND intentions.processing_time < (:time_limit)
      OR intentions.state = 'interviewed' AND intentions.interviewed_time < (:time_limit)
    SQL

    with_customer.where(sql, time_limit: (Time.zone.now.beginning_of_day - recovery_time.days))
  }

  # for 联盟后台
  scope :alliance_assigned_on,
        lambda { |date|
          where("intentions.alliance_assigned_at between ? and ?",
                Util::Date.parse_date_string(date).beginning_of_day,
                Util::Date.parse_date_string(date).end_of_day)
        }
  scope :in_shop_on,
        lambda { |date|
          where("intentions.in_shop_at between ? and ?",
                Util::Date.parse_date_string(date).beginning_of_day,
                Util::Date.parse_date_string(date).end_of_day)
        }

  scope :interviewed_on,
        lambda { |date|
          joins(:intention_push_histories)
            .where("intention_push_histories.interviewed_time between ? and ?",
                   Util::Date.parse_date_string(date).beginning_of_day,
                   Util::Date.parse_date_string(date).end_of_day)
        }

  scope :created_on,
        lambda { |date|
          where("intentions.created_at between ? and ?",
                Util::Date.parse_date_string(date).beginning_of_day,
                Util::Date.parse_date_string(date).end_of_day).uniq
        }

  # additional config .........................................................
  ransacker :created_at do
    Arel.sql("date(#{table_name}.created_at AT TIME ZONE 'GMT+8')")
  end

  acts_as_paranoid

  delegate :memory_dates, to: :customer, allow_nil: true

  # demands#274
  IntentionAuthority = {
    "seek" => %w(全部求购客户管理 求购客户管理).map(&:freeze).freeze,
    "sale" => %w(全部出售客户管理 出售客户管理).map(&:freeze).freeze
  }.freeze

  # 未指派, 待跟进，跟进中，已预约，已预定，取消预定，已成交，已收购，厅寄，网寄，已战败，无效
  enumerize :state,
            in: %i(
              untreated pending processing interviewed reserved cancel_reserved
              completed acquired hall_consignment online_consignment failed invalid
            ),
            groups: {
              unfinished: %i(
                untreated pending processing interviewed reserved cancel_reserved
                hall_consignment online_consignment
              ),
              finished: %i(
                completed acquired failed invalid
              ),
              completed: %i(completed acquired)
            }

  enumerize :alliance_state,
            in: %i(
              untreated pending processing interviewed reserved cancel_reserved
              completed acquired hall_consignment online_consignment failed invalid
            )

  enumerize :gender, in: %i(female male)
  enumerize :intention_type, in: %i(seek sale), predicates: { prefix: true }

  price_wan :minimum_price, :maximum_price, :estimated_price, :deposit, :closing_cost
  price_yuan :minimum_price, :maximum_price

  # class methods .............................................................
  class << self
    def order_by_state(is_alliance = false)
      column_name = is_alliance ? "intentions.alliance_state" : "intentions.state"
      sort = 0

      unfinished_sql = %i(pending processing interviewed reserved).map do |state|
        "when '#{state}' then #{sort += 1}"
      end.join(" ")

      finished_sql = %i(
        completed acquired hall_consignment online_consignment failed invalid
      ).map do |state|
        "when '#{state}' then #{sort += 1}"
      end.join(" ")

      <<-SQL.squish!
        case #{column_name}
        #{unfinished_sql} #{finished_sql}
        else 100
        end
      SQL
    end

    def order_sql(order_field, order_by)
      return "#{order_field} #{order_by}" unless order_field == "due_time"

      <<-SQL.squish!
        extract(
          epoch FROM age(
            COALESCE(
              intentions.processing_time,
              intentions.interviewed_time,
              intentions.created_at
            ),
            current_timestamp)
        ) #{order_by}
      SQL
    end

    def intention_scope(company_id)
      Intention.where(company_id: company_id).with_customer
    end

    def ransackable_scopes(_auth_object = nil)
      %i(keyword alliance_assigned_on in_shop_on interviewed_on created_on)
    end
  end

  # public instance methods ...................................................

  def processing_time
    self[:processing_time].try(:to_date)
  end

  def seek_description
    [
      seeking_cars.map { |seek_car| "#{seek_car.brand_name} #{seek_car.series_name}" }
                  .join("、"),
      price_range_text
    ].join("; ")
  end

  def seeking_cars
    @_seeking_cars ||= self[:seeking_cars].map do |car|
      SeekingCar.new(
        car["brand_name"], car["series_name"],
        car["minimum_price_wan"], car["maximum_price_wan"]
      )
    end
  end

  def intention_cars_text
    if intention_type_seek?
      seeking_cars.map do |car|
        "#{car.brand_name} #{car.series_name}"
      end.join("，")
    else
      "#{brand_name} #{series_name}"
    end
  end

  def sale_description
    [
      brand_name,
      series_name,
      style_name
    ].reject(&:blank?).join(" ")
  end

  def price_range_text
    if minimum_price_cents.present?
      if maximum_price_cents.present?
        "#{minimum_price_wan} - #{maximum_price_wan} 万元"
      else
        "最低 #{minimum_price_wan} 万元"
      end
    elsif maximum_price_cents.present?
      "最高 #{maximum_price_wan} 万元"
    end
  end

  def intention_type_authority
    IntentionAuthority[intention_type]
  end

  def seeking_cars_condition
    sql = []
    sql << seeking_car_price_condition

    sql << (seeking_cars || [])
           .map(&:to_sql)
           .reject(&:blank?)
           .join(" OR ")

    result = sql.reject(&:blank?)

    result.blank? ? "1=0" : result.join(" AND ")
  end

  def seeking_car_price_condition
    return if minimum_price_cents.to_i == 0 && maximum_price_cents.to_i == 0

    arr = []
    if minimum_price_cents.present?
      arr << "cars.show_price_cents >= '#{minimum_price_cents}'"
    end

    if maximum_price_cents.present?
      arr << "cars.show_price_cents <= '#{maximum_price_cents}'"
    end

    arr.join(" AND ")
  end

  def notice_new_assigee(operator)
    return unless assignee_id_changed?

    operation_records.create!(
      user: operator,
      company_id: operator.company_id,
      operation_record_type: :intention_reassigned,
      shop_id: operator.shop_id,
      messages: {
        intention_id: id,
        intention_type: intention_type,
        title: "新分配客户",
        user_name: operator.name,
        customer_name: customer_name,
        assignee_id: assignee_id,
        assignee_id_was: assignee_id_was
      },
      user_passport: operator.passport.to_h
    )
  end

  def from_alliance_company?
    alliance_company_id.present?
  end

  def transfer_to_acquisition_info(source)
    case source
    when :online
      AcquisitionCarInfo.create!(
        acquirer_id: nil,
        brand_name: brand_name,
        series_name: series_name,
        style_name: style_name,
        licensed_at: licensed_at,
        mileage: mileage,
        valuation_cents: minimum_price_cents,
        owner_info: { phone: customer_phone },
        company_id: company_id
      )
    end
  end

  def to_be_recycled?
    recovery_time = company.try(:intention_expiration).try(:recovery_time)
    return if recovery_time.to_i == 0

    state == "failed" || state == "invalid" || state_time_limit(state, recovery_time)
  end

  def state_time_limit(state, recovery_time)
    time_limit = (Time.zone.now.beginning_of_day - recovery_time.days)
    (state == "processing" && processing_time < time_limit) ||
      (state == "interviewed" && interviewed_time < time_limit)
  end

  # 返回 customer里的memory_dates，以及是否过期信息
  def memory_dates_with_flag
    return [] if memory_dates.blank?
    memory_dates.each_with_object([]) do |md, acc|
      date_str = md.fetch("date")
      year = DateTime.current.year
      setting_date = Time.zone.parse("#{year}-#{date_str}").to_date
      current_date = Time.zone.today.to_date

      md[:expired_flag] = (setting_date - current_date).to_i <= 0

      acc << md
    end
  end

  # 已成交的意向，得到购买车辆的付款方式
  def finished_payment_type
    return unless state == "completed"
    return if closing_car_id.blank?
    car = Car.find(closing_car_id)
    payment_type_str = car.stock_out_inventory.try(:payment_type)
    {
      "cash" => "现款",
      "mortgage" => "按揭"
    }.fetch(payment_type_str, "")
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def init_processing_time
    return unless processing_time.present?

    self.processing_time = processing_time.beginning_of_day.change(hour: 8)
  end

  def company_presence
    !(company_id || alliance_company_id)
  end

  def set_creator_type
    self.creator_type ||= "User"
  end
end
