# == Schema Information
#
# Table name: acquisition_car_infos # 收车信息
#
#  id                         :integer          not null, primary key # 收车信息
#  brand_name                 :string                                 # 品牌名称
#  series_name                :string                                 # 车系名称
#  style_name                 :string                                 # 车型名称
#  acquirer_id                :integer                                # 发布收车信息的人ID
#  licensed_at                :date                                   # licensed_at
#  new_car_guide_price_cents  :integer                                # 新车指导价
#  new_car_final_price_cents  :integer                                # 新车完税价
#  manufactured_at            :date                                   # 出厂日期
#  mileage                    :float                                  # 表显里程(万公里)
#  exterior_color             :string                                 # 外饰颜色
#  interior_color             :string                                 # 内饰颜色
#  displacement               :float                                  # 排气量
#  prepare_estimated_cents    :integer                                # 整备预算
#  manufacturer_configuration :hstore                                 # 车辆配置
#  valuation_cents            :integer                                # 收车人估价
#  state                      :string                                 # 收车信息状态
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  note_text                  :text                                   # 文字备注
#  key_count                  :integer                                # 车辆钥匙数
#  images                     :jsonb            is an Array           # 多张图片信息
#  owner_info                 :jsonb                                  # 原车主信息
#  is_turbo_charger           :boolean          default(FALSE)        # 是否自然排气
#  note_audios                :jsonb            is an Array           # 多条语音备注
#  configuration_note         :string                                 # 配置说明
#  procedure_items            :jsonb                                  # 手续信息
#  license_info               :string                                 # 牌证信息
#  company_id                 :integer                                # 发布者所属公司
#  intention_level_name       :string                                 # 客户等级
#  car_id                     :integer                                # 确认收购后关联的在库车辆
#  closing_cost_cents         :integer                                # 确认收购价
#

class AcquisitionCarInfo < ActiveRecord::Base
  OwnerIntention = Struct.new(:name, :phone, :expected_price_wan, :intention_level, :channel)
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  extend EnumerizeWithGroups
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :acquirer, class_name: "User"
  belongs_to :company
  belongs_to :car

  has_many :comments, -> { order(created_at: :desc) }, class_name: "AcquisitionCarComment"
  has_many :publish_records, class_name: "CarInfoPublishRecord"
  has_many :chat_groups, through: :publish_records, source: :chatable, source_type: "ChatGroup"
  has_many :operation_records, -> { order("id desc") }, as: :targetable
  has_one :acquisition_confirmation

  # validations ...............................................................
  # callbacks .................................................................
  before_save :set_intention_level_name, :set_state
  # scopes ....................................................................
  scope :unassigned, -> { where(acquirer_id: nil) }
  # additional config .........................................................
  enumerize :state,
            in: %i(init finished unassigned), default: :init
  enumerize :license_info, in: %i(licensed unlicensed new_car), predicates: true

  serialize :manufacturer_configuration, ActiveRecord::Coders::NestedHstore

  price_wan :new_car_guide_price, :new_car_final_price, :valuation, :closing_cost
  price_yuan :prepare_estimated

  delegate :name, to: :acquirer, prefix: true, allow_nil: true
  delegate :name, to: :company, prefix: true, allow_nil: true
  # class methods .............................................................
  # public instance methods ...................................................
  def seller_company
    Company.where(id: comments.select(:company_id).where(is_seller: true).limit(1)).first
  end

  def owner_intention
    return OwnerIntention.new(nil, nil, nil, {}, {}) if owner_info.blank?
    intention_level = owner_info.fetch("intention_level", {}) || {}
    channel = owner_info.fetch("channel", {}) || {}

    OwnerIntention.new(
      owner_info.fetch("name", nil),
      owner_info.fetch("phone", nil),
      owner_info.fetch("expected_price_wan", nil),
      intention_level,
      channel
    )
  end

  def seller_user
    case state.to_s
    when "init"
      comment = comments.includes(:commenter, :company).where(is_seller: true).first
      return {} unless comment
      cooperater_hash(comment.commenter)
    when "finished"
      cooperater_hash(acquisition_confirmation.company.owner)
    end
  end

  def cooperate_companies
    Company.where(id: comments.select(:company_id).where(cooperate: true)).all
  end

  # 只返回合作者，不包括销售方
  def cooperates
    case state.to_s
    when "init"
      cooperate_comments = comments.includes(:commenter, :company)
                                   .where(cooperate: true)
                                   .where.not(is_seller: true)
                                   .order(created_at: :desc)
      cooperate_comments.each_with_object([]) do |comment, arr|
        user = comment.commenter
        arr << cooperater_hash(user)
      end
    when "finished"
      joins_sql = <<-SQL.squish!
        LEFT JOIN companies
        ON users.id = companies.owner_id
      SQL

      seller_id = acquisition_confirmation.company_id
      company_ids = acquisition_confirmation.cooperate_companies
                                            .delete_if { |id| id == seller_id }

      users = User.joins(joins_sql)
                  .where(
                    "companies.id in (?)",
                    company_ids)

      users.each_with_object([]) do |user, arr|
        arr << cooperater_hash(user)
      end
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_state
    self.state = "unassigned" if acquirer_id.nil?
  end

  def set_intention_level_name
    self.intention_level_name = owner_intention.intention_level.fetch("name", "")
  end

  def cooperater_hash(user)
    {
      user_name: user.name,
      avatar: user.avatar,
      company_name: user.company.name,
      company_id: user.company.id,
      user_id: user.id
    }
  end
end
