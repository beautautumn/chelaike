# == Schema Information
#
# Table name: users # 用户
#
#  id                         :integer          not null, primary key    # 用户
#  name                       :string           not null                 # 姓名
#  username                   :string                                    # 用户名
#  password_digest            :string           not null                 # 加密密码
#  email                      :string                                    # 邮箱
#  pass_reset_token           :string                                    # 重置密码token
#  phone                      :string                                    # 手机号码
#  state                      :string           default("enabled")       # 状态
#  is_alliance_contact        :boolean          default(FALSE)           # 是否联盟联系人
#  pass_reset_expired_at      :datetime                                  # 重置密码token过期时间
#  last_sign_in_at            :datetime                                  # 最后登录时间
#  current_sign_in_at         :datetime                                  # 当前登录时间
#  company_id                 :integer                                   # 所属公司
#  shop_id                    :integer                                   # 所属分店
#  manager_id                 :integer                                   # 所属经理
#  note                       :text                                      # 员工描述
#  authority_type             :string           default("role")          # 权限选择类型
#  authorities                :text             default([]), is an Array # 权限
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  deleted_at                 :datetime                                  # 删除时间
#  avatar                     :string                                    # 头像URL
#  settings                   :jsonb                                     # 设置
#  mac_address                :string                                    # MAC地址
#  cross_shop_authorities     :text             default([]), is an Array # 跨店权限
#  device_numbers             :text             default([]), is an Array # App设备号
#  client_info                :jsonb                                     # 客户端信息
#  first_letter               :string                                    # 拼音
#  mobile_app_car_detail_menu :string           is an Array              # 移动APP车辆详情页菜单
#  rc_token                   :string                                    # 融云token
#  current_device_number      :string                                    # 用户当前使用的手机设备号
#  qrcode_url                 :string                                    # 二维码地址
#  self_description           :text                                      # 自我介绍
#

class User < ActiveRecord::Base
  class Anonymous
    attr_accessor :id, :company, :shop_id

    def initialize(company: nil)
      self.company = company
    end

    def can?(*_authorities)
      false
    end

    def cross_shop_can?(*_authorities)
      company_unified_management
    end

    def customers
      Customer
    end
  end

  class Pundit
    class << self
      attr_accessor :authorities
    end

    def self.can?(user)
      user.can?(*authorities)
    end

    def self.cross_shop_can?(user)
      user.cross_shop_can?(*authorities)
    end

    def self.can_can?(user, record, authorities)
      self.authorities = authorities

      return can?(user) if record.shop_id == user.shop_id
      cross_shop_can?(user)
    end

    def self.filter(user, record, authorities)
      return false unless record
      return true if user.is_a?(AllianceCompany::User)
      return user.can?(*authorities) if record.shop_id == user.shop_id

      user.cross_shop_can?(*authorities)
    end
  end

  class Unauthorized < StandardError; end
  class SingleLoginError < StandardError; end
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include BCrypt
  include FirstLetter
  include Passport
  include UserChat
  # relationships .............................................................
  belongs_to :company
  belongs_to :shop, -> { with_deleted }

  has_one :owned_company, class_name: "Company", foreign_key: :owner_id
  belongs_to :manager, class_name: "User", foreign_key: :manager_id

  has_many :feedbacks
  has_many :authority_role_relationships
  has_many :authority_roles, through: :authority_role_relationships,
                             source: :authority_role
  has_many :messages do
    def mark_as_read!
      update_all(read: true, read_at: Time.zone.now)
    end
  end
  has_many :unread_messages, -> { unread }, class_name: "Message"

  has_many :operation_records, through: :messages
  has_many :unread_operation_records, through: :unread_messages, source: :operation_record
  has_many :customers
  has_many :intentions, foreign_key: :assignee_id
  has_many :intention_shared_users, foreign_key: :user_id
  has_many :shared_intentions, class_name: "Intention",
                               through: :intention_shared_users,
                               source: :intention

  has_many :subordinate_users, foreign_key: :manager_id, class_name: "User"
  has_many :active_intentions,
           -> { state_unfinished_scope },
           class_name: "Intention",
           foreign_key: :assignee_id

  has_many :acquisition_car_infos, foreign_key: :acquirer_id

  has_many :token_bills, foreign_key: :operator_id, class_name: "TokenBill"

  # validations ...............................................................
  validates :phone,
            uniqueness_without_deleted: true, presence: true
  validates :username,
            uniqueness_without_deleted: true, if: :username
  # callbacks .................................................................
  before_save :set_authorities!, :set_cross_shop_authorities!
  before_save :check_username_avatar
  before_destroy :quit_groups

  after_commit :refresh_rongcloud
  # scopes ....................................................................
  scope :order_by_state, lambda {
    order(
      <<-SQL.squish!
        CASE users.state
        WHEN 'enabled' THEN 0 ELSE 1
        END
      SQL
    )
  }
  scope :enabled, -> { where(state: "enabled") }
  scope :alliance_contacts, -> { where(is_alliance_contact: true) }
  scope :subordinate_users_with_self, -> (id) { where("manager_id = :id OR id = :id", id: id).uniq }
  scope :by_authority, -> (type) { where("messages->>'stock_out_type' = ?", type) }
  scope :authorities_include,
        -> (*authorities) { where("users.authorities @> ARRAY[?]", authorities) }
  scope :authorities_any,
        -> (*authorities) { where("users.authorities && ARRAY[?]", authorities) }
  scope :authorities_without,
        -> (*authorities) { where.not("users.authorities && ARRAY[?]", authorities) }

  # additional config .........................................................
  acts_as_paranoid

  has_secure_password

  enumerize :authority_type, in: %w(role custom)
  enumerize :state, in: %w(enabled disabled), predicates: true

  accepts_nested_attributes_for :feedbacks, allow_destroy: true

  typed_store :settings, coder: DumbCoder do |s|
    s.boolean :mac_address_lock, null: false, default: false
    s.boolean :device_number_lock, null: false, default: false
    s.boolean :cross_shop_read, null: false, default: false
    s.boolean :cross_shop_edit, null: false, default: false
    s.boolean :cross_shop_read_statistic, null: false, default: false
  end

  delegate :unified_management, to: :company, allow_nil: true, prefix: true

  # class methods .............................................................
  def self.authorities
    authority_values(YAML.load_file("#{Rails.root}/config/authorities.yml"))
  end

  def self.authority_values(hash)
    Rails.cache.fetch(Digest::MD5.hexdigest(hash.to_json)) do
      hash.each_with_object([]) do |(_, value), authorities|
        authorities << value.keys
      end.flatten!
    end
  end

  def self.authorities_hash
    YAML.load_file("#{Rails.root}/config/authorities.yml")
        .each_with_object([]) do |(key, value), arr|
      arr << {}.tap do |hash|
        hash[:category] = key

        hash[:authorities] = value.inject([]) do |array, (k, v)|
          array << {
            name: k,
            description: v
          }
        end
      end
    end
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i(authorities_include authorities_any)
  end

  def self.authority_valid?(*actions)
    (actions - authorities).empty?
  end

  # public instance methods ...................................................
  def token
    generate_token(
      user_id: id,
      settings: settings,
      password_digest: password_digest,
      authorities: "#{Digest::MD5.hexdigest(authorities.to_json)}-v3.0.0",
      cross_shop_authorities: Digest::MD5.hexdigest(cross_shop_authorities.to_json)
    )
  end

  def simple_token
    generate_token(user_id: id)
  end

  def can?(*actions)
    (actions - authorities).empty?
  end

  def cross_shop_can?(*actions)
    if company_unified_management
      can?(*actions)
    else
      (actions - cross_shop_authorities).empty?
    end
  end

  def pass_reset_token_valid?(token, _phone)
    !reset_password_limited? &&
      within_pass_reset_expiry? && pass_reset_token && pass_reset_token == token
  end

  def set_reset_password_limit_key
    RedisClient.current.set reset_password_limit_key, 1, ex: 600
  end

  def locked?
    mac_address_lock || device_number_lock
  end

  def mac_address_valid?(_mac_addresses)
    # return true unless mac_address_lock
    # return false unless mac_addresses.present?

    # mac_addresses.split(",").map(&:squish).include?(mac_address)
    # ./spec/models/user_spec.rb:103 测试请打开
    true # 经讨论, 先服务器不校验,
  end

  def device_number_valid?(device_number)
    return true unless device_number_lock
    return false unless device_number.present?

    device_numbers.include?(device_number)
  end

  def mobile_app_car_detail_menu
    menu = self[:mobile_app_car_detail_menu]

    return menu if menu.present?

    %w(
      basic_info public_praise configuration similar
      maintenance_record transaction_information transfer_record prepare_record
      micro_contract
    )
  end

  def all_intentions
    join_sql = <<-SQL.squish!
      LEFT OUTER JOIN intention_shared_users
        ON intention_shared_users.intention_id = intentions.id
    SQL

    where_sql = <<-SQL.squish!
      intentions.assignee_id = :user_id
      OR
      intention_shared_users.user_id = :user_id
    SQL

    Intention.joins(join_sql).where(where_sql, user_id: id)
  end

  # protected instance methods ................................................
  def authorities_by_roles
    authority_roles.collect { |e| e[:authorities] }.flatten.uniq.sort!
  end

  def authorities
    (self[:authorities] || []) + ["车币充值"]
  end

  def cache_uuid
    "#{id}:#{updated_at.to_i}"
  end

  def business_manager?(business_type)
    return true if can?("全部客户管理")
    business_type == "seek" ? can?("全部求购客户管理") : can?("全部出售客户管理")
  end

  # private instance methods ..................................................

  private

  def reset_password_limit_key
    @reset_password_limit_key ||= "RESET_PASSWORD:#{phone}"
  end

  def reset_password_limited?
    count = RedisClient.current.get(reset_password_limit_key).try(:to_i)

    return true if count.nil? || count > 10

    RedisClient.current.incr reset_password_limit_key

    false
  end

  def within_pass_reset_expiry?
    pass_reset_expired_at && pass_reset_expired_at >= Time.zone.now
  end

  def set_authorities!
    case authority_type
    when "role"
      self.authorities = authorities_by_roles
    when "custom"
      authority_roles.clear
    end
  end

  def set_cross_shop_authorities!
    self.cross_shop_authorities = []
    return unless cross_shop_read || cross_shop_edit
    hash = YAML.load_file("#{Rails.root}/config/cross_shop_authorities.yml")

    arr = []
    arr << self.class.authority_values(hash["跨店查询权限"]) if cross_shop_read
    arr << authorities if cross_shop_edit

    self.cross_shop_authorities = arr.flatten!.uniq
  end

  def check_username_avatar
    @_tobe_refresh = username_changed? || avatar_changed?
    true
  end

  def refresh_rongcloud
    return unless disabled? || @_tobe_refresh

    action = if disabled?
               "quit_all_groups"
             elsif @_tobe_refresh
               "refresh"
             end
    RongCloudUserWorker.perform_async(action, id)
  end

  def quit_groups
    RongCloudUserWorker.perform_async("quit_all_groups", id)
  end

  def generate_token(payload)
    jwt = JWT.encode payload, Rails.application.secrets[:secret_token], "HS256"

    "AutobotsAuth #{jwt}"
  end
end
