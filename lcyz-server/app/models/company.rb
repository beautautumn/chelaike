# == Schema Information
#
# Table name: companies # 公司
#
#  id                      :integer          not null, primary key # 公司
#  name                    :string                                 # 名称
#  contact                 :string                                 # 联系人
#  contact_mobile          :string                                 # 联系人电话
#  acquisition_mobile      :string                                 # 收购电话
#  sale_mobile             :string                                 # 销售电话
#  logo                    :string                                 # LOGO
#  note                    :string                                 # 备注
#  province                :string                                 # 省份
#  city                    :string                                 # 城市
#  district                :string                                 # 区
#  street                  :string                                 # 详细地址
#  owner_id                :integer                                # 公司拥有者ID
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  settings                :jsonb                                  # 设置
#  deleted_at              :datetime                               # 删除时间
#  md5_name                :string                                 # 兼容老系统的名称MD5值
#  slogan                  :text                                   # 宣传语
#  alliances_count         :integer                                # 联盟数量
#  cars_count              :integer                                # 车辆数量
#  active_tag              :boolean          default(FALSE)        # 活跃标识
#  honesty_tag             :boolean                                # 诚信标识
#  own_brand_tag           :boolean                                # 品牌商家标识
#  app_secret              :string                                 # 商家secret
#  youhaosuda_shop_token   :string                                 # 友好速搭商铺Token
#  open_alliance_id        :integer                                # 开放联盟ID
#  erp_id                  :string                                 # ERP 识别号
#  erp_url                 :string                                 # ERP 通知地址
#  che168_profile          :jsonb                                  # che168信息
#  qrcode                  :string                                 # 商家二维码
#  banners                 :string           is an Array           # 网站Banners
#  shops_count             :integer          default(0)
#  alliance_company_id     :integer                                # 所属品牌联盟的联盟公司
#  official_website_url    :string                                 # 官网地址
#  financial_configuration :jsonb                                  # 财务设置
#  alliance_manager_id     :integer                                # 这家公司所对应的联盟管理公司ID
#  facade                  :string           default("")           # 公司的门头照片
#  industry_rating         :decimal(, )      default(3.0)          # 默认行业风评等级
#  assets_debts_rating     :decimal(, )      default(0.6)          # 默认资产负债率
#

class Company < ActiveRecord::Base
  class Unauthorized < StandardError; end
  # accessors .................................................................
  attr_readonly :alliances_count
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :owner, foreign_key: :owner_id, class_name: "User"

  has_many :authority_roles, dependent: :destroy
  has_many :channels, dependent: :destroy, as: :company
  has_many :intention_push_fail_reasons, dependent: :destroy
  has_many :shops, dependent: :destroy
  has_many :insurance_companies, dependent: :destroy
  has_many :mortgage_companies, dependent: :destroy
  has_many :cooperation_companies, dependent: :destroy
  has_many :warranties, dependent: :destroy
  has_many :imported_cars, -> { where("imported is not null") }, class_name: Car.name
  has_many :cars, dependent: :destroy
  has_many :in_stock_cars, -> { state_in_stock_scope }, class_name: "Car"
  has_many :users, dependent: :destroy
  has_many :chat_users, -> { authorities_include("联盟管理") }, class_name: "User"
  has_many :customers, dependent: :destroy
  has_many :enabled_users, -> { enabled }, class_name: User.name
  has_many :alliance_contacts, -> { alliance_contacts },
           class_name: "User", dependent: :destroy
  has_many :price_tag_templates, dependent: :destroy

  has_many :app_version_company_relationships, dependent: :destroy
  has_many :app_versions, through: :app_version_company_relationships,
                          source: :app_version

  has_many :alliance_company_relationships, dependent: :destroy

  has_many :alliances, through: :alliance_company_relationships,
                       source: :alliance
  belongs_to :alliance_company, class_name: "AllianceCompany::Company",
                                foreign_key: :alliance_company_id
  belongs_to :open_alliance, class_name: Alliance.name, foreign_key: :open_alliance_id
  belongs_to :alliance_manager, class_name: "AllianceCompany::Company"

  has_many :allied_companies, -> { uniq }, through: :alliances, source: :companies
  has_many :all_allied_cars, -> { uniq }, through: :alliances, source: :all_cars
  has_many :all_open_allied_cars, through: :open_alliance, source: :all_cars
  has_many :open_allied_users, -> { uniq }, through: :open_alliance, source: :users
  has_many :operation_records
  has_many :intention_levels, as: :company
  has_many :intentions
  has_many :service_appointments

  has_one :wechat_app, as: :company, dependent: :destroy
  has_many :chat_groups, as: :organize, dependent: :destroy
  has_many :che168_publish_records, dependent: :destroy
  has_one :che168_profile, class_name: "Publisher::Che168Profile", dependent: :destroy
  has_one :platform_profile, dependent: :destroy

  has_many :daily_active_records
  has_many :acquisition_car_infos
  has_many :unassigned_acquisition_car_infos, -> { unassigned },
           class_name: "AcquisitionCarInfo"

  # 目前每个公司只有统一的意向过期时间设置, 以后可能根据客户等级细分
  has_one :intention_expiration, dependent: :destroy

  has_many :finance_car_incomes, class_name: "Finance::CarIncome", dependent: :destroy

  has_many :orders
  has_many :success_orders, -> { where(status: "success") }, class_name: "Order"
  has_many :expiration_settings, class_name: "ExpirationSetting"

  # 金融相关关系
  has_many :accredited_records, class_name: "EasyLoan::AccreditedRecord"
  has_many :loan_bills, -> { order(created_at: :desc) },
           class_name: "EasyLoan::LoanBill"
  has_many :easy_loan_debits, class_name: "EasyLoan::Debit"
  has_many :owner_companies, class_name: "OwnerCompany"

  # validations ...............................................................
  validates :name, uniqueness_without_deleted: true, presence: true
  # callbacks .................................................................
  before_save :set_md5_name, :update_report_task
  before_create :set_app_secret
  after_commit :update_chat_groups, on: :update
  after_create :init_expiration_settings
  after_create :setup_tenant_in_official_site # 开通官网
  # scopes ....................................................................
  # additional config .........................................................
  acts_as_paranoid

  accepts_nested_attributes_for :authority_roles, allow_destroy: true

  typed_store :settings, coder: DumbCoder do |s|
    s.boolean :automated_stock_number, null: false, default: false
    s.string :automated_stock_number_prefix
    s.integer :automated_stock_number_start
    s.string :daily_reported_at, null: false, default: "18:30"
    s.boolean :unified_management, null: false, default: true
    s.boolean :stock_number_by_vin, null: false, default: false
  end

  typed_store :financial_configuration, coder: DumbCoder do |f|
    f.decimal :fund_rate, null: false, default: 1.0             # 资金月利率(%)
    f.boolean :fund_by_company, default: false                  # 按公司/按车计算资金成本, 默认按车
    f.decimal :fund_total_wan, default: 0                       # 资金总额(万元)
    # 场租成本目前是按公司整体计算(每月费用*月), 未来可能有按单车计算(单车场租*在库天数)
    f.string  :rent_by, default: "area"
    # 按车位(unit)/按面积(area)计算场租, 默认按面积
    # 如果按车位结算, 每月场租 = 场租单价(元/个/年) * 车位数 / 12
    # 如果按面积结算, 每月场租 = 场租单价(元/平米/天) * 核算面积 * 30
    f.decimal :rent, default: 0                                 # 场租单价
    f.decimal :area, default: 0                                 # 公司核算面积(平米)/车位(个)
    f.decimal :gearing, default: 0                              # 融资比例(%)
  end

  # class methods .............................................................
  # public instance methods ...................................................
  def token
    payload = {
      expired_at: Time.zone.now + 1.day,
      id: id
    }
    JWT.encode payload, ENV.fetch("OPEN_APP_SECRET"), "HS256"
  end

  def in_alliances
    @_in_alliances ||= alliances && !alliances.empty?
  end

  def cars_count
    @_cars_count ||= cars.state_in_stock_scope.where(reserved: false).count
  end

  def current_app_version(category)
    category ||= "chelaike"
    type = "production"

    app = App.find_by!(alias: category)

    last_production_version = app.latest_version("production").version_number
    last_development_version = app_versions
                               .where(app_id: app.id)
                               .maximum(:version_number)

    version = [last_production_version, last_development_version].compact.max
    type = "development" if last_development_version == version

    app.app_versions.find_by!(version_number: version, version_type: type)
  end

  def ready_to_report_today
    time = Util::Datetime.from_string_time(daily_reported_at)
    return if time < Time.zone.now

    DailyReportWorker.perform_in(time, id)
  end

  def recent_operation_records(days_before, end_date = nil)
    end_date = Time.zone.today if end_date.nil?
    operation_records.valid.where(
      "created_at between ? and ?",
      end_date.beginning_of_day - days_before,
      end_date.end_of_day
    )
  end

  def allied_cars
    black_listed_car_ids = []
    alliances.each do |alliance|
      black_listed_car_ids << alliance.car_alliance_blacklists.pluck(:car_id)
    end
    @allied_cars ||= all_allied_cars
                     .where.not(id: black_listed_car_ids.flatten.uniq)
  end

  def open_allied_cars
    black_listed_car_ids = open_alliance.car_alliance_blacklists.pluck(:car_id)
    @open_allied_cars ||= all_open_allied_cars
                          .where.not(id: black_listed_car_ids.flatten.uniq)
  end

  # 先注释掉，这个值直接从DB里去得到
  def official_website(app_version)
    website = self[:official_website_url]
    return website if website.present?

    if app_version < "3.3.7"
      nil
    else
      "http://#{id}.#{ENV['WESHOP_DOMAIN']}"
    end
    # Company::OfficialWebsiteUrlService.new(self).execute
  end

  def nickname
    return "" unless alliance_company
    alliance = alliance_company.alliance
    alliance_company_relationships.where(alliance_id: alliance.id).first.nickname
  end

  def address
    "#{province}#{city}#{district}#{street}"
  end

  def find_or_create_shop(shop_name)
    Shop.find_or_create_by(
      company_id: id,
      name: shop_name
    )
  end

  def latest_loan_debit
    easy_loan_debits.order(created_at: :desc).first
  end

  # 得到所有分店的城市名
  def cities_name
    shops.map(&:city).uniq
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_app_secret
    self.app_secret = SecureRandom.hex
  end

  def set_md5_name
    self.md5_name = Digest::MD5.hexdigest(name) if md5_name.blank?
  end

  def update_report_task
    return unless daily_reported_at_changed?

    schedule = Sidekiq::ScheduledSet.new
    jobs = schedule.select do |retri|
      retri.klass == "DailyReportWorker" && retri.args == [id]
    end

    jobs.last.try(&:delete)
    ready_to_report_today
  end

  def update_chat_groups
    if chat_groups
      chat_groups.each do |group|
        group.update(
          name: group_name(group),
          logo: logo
        )
      end
    end
  end

  def group_name(group)
    case group.group_type.to_s
    when "sale".freeze
      "#{name}销售群"
    when "acquisition".freeze
      "#{name}收购群"
    end
  end

  def init_expiration_settings
    ExpirationSetting.init(self)
  end

  # 开通官网
  def setup_tenant_in_official_site
    Car::WeshopService.new.setup_tenant_in_weshop(self)
  end
end
