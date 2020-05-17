# == Schema Information
#
# Table name: chat_groups
#
#  id            :integer          not null, primary key
#  organize_id   :integer                                      # 所属组织
#  organize_type :string                                       # 所属组织
#  name          :string           not null                    # 群组名称
#  state         :string           default("enable"), not null # 群组状态
#  group_type    :string           default("sale"), not null   # 群组类型
#  owner_id      :integer          not null                    # 群主
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  logo          :string                                       # 群组logo
#

class ChatGroup < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :organize, polymorphic: true
  belongs_to :owner, foreign_key: :owner_id, class_name: "User"
  has_many :chat_sessions, as: :target
  has_many :users, through: :chat_sessions

  has_many :car_info_publish_records, as: :chatable
  has_many :acquisition_car_infos, through: :car_info_publish_records
  # validations ...............................................................
  # callbacks .................................................................
  before_save :set_default_logo
  # scopes ....................................................................
  scope :own_by_company, -> { where(organize_type: "Company") }
  scope :own_by_alliance, -> { where(organize_type: "Alliance") }
  scope :in_use, -> { with_state(:enable) }
  scope :disabled, -> { with_state(:disable) }
  # additional config .........................................................
  enumerize :state, in: [:enable, :disable], scope: true
  enumerize :group_type, in: [:sale, :acquisition]
  # class methods .............................................................
  # public instance methods ...................................................

  def own_by_company?
    organize_type == "Company"
  end

  def own_by_alliance?
    organize_type == "Alliance"
  end

  def user_id_nickname_hash
    if own_by_company?
      {}.tap { |hash| users.each { |u| hash[u.id] = u.name } }
    elsif own_by_alliance?
      acrs = organize.alliance_company_relationships.includes(:company)
      company_nickname_hash = {}.tap do |hash|
        acrs.each do |acr|
          name = acr.nickname || acr.company.name
          hash[acr.company_id] = name
        end
      end
      {}.tap do |hash|
        users.each do |u|
          hash[u.id] = "#{u.name}-#{company_nickname_hash[u.company_id]}"
        end
      end
    end
  end

  def rongcloud_id
    rc_prefix = ENV["RC_PREFIX"] || ""
    rc_prefix = "#{rc_prefix}_" if rc_prefix.present?
    "#{rc_prefix}#{id}"
  end

  def user_rongcloud_ids
    users.map(&:rongcloud_id)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  def set_default_logo
    self.logo ||= default_logo
  end

  def default_logo
    case organize_type
    when "Company".freeze
      organize.logo
    when "Alliance".freeze
      organize.avatar
    end
  end
end
