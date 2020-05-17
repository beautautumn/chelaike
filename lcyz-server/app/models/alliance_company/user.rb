# == Schema Information
#
# Table name: alliance_users # 联盟公司的用户
#
#  id                    :integer          not null, primary key    # 联盟公司的用户
#  name                  :string           not null                 # 姓名
#  username              :string                                    # 用户名
#  password_digest       :string           not null                 # 加密密码
#  email                 :string                                    # 邮箱
#  pass_reset_token      :string                                    # 重置密码token
#  phone                 :string                                    # 手机号码
#  state                 :string           default("enabled")       # 状态
#  pass_reset_expired_at :datetime                                  # 重置密码token过期时间
#  last_sign_in_at       :datetime                                  # 最后登录时间
#  current_sign_in_at    :datetime                                  # 当前登录时间
#  company_id            :integer                                   # 所属公司
#  manager_id            :integer                                   # 所属经理
#  note                  :text                                      # 员工描述
#  authority_type        :string           default("role")          # 权限选择类型
#  authorities           :text             default([]), is an Array # 权限
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  deleted_at            :datetime                                  # 删除时间
#  avatar                :string                                    # 头像URL
#  settings              :jsonb                                     # 设置
#  first_letter          :string                                    # 拼音
#

class AllianceCompany::User < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize

  # includes ..................................................................
  include BCrypt
  include FirstLetter
  include Passport
  # relationships .............................................................
  belongs_to :alliance_company, class_name: "AllianceCompany::Company",
                                foreign_key: :company_id

  has_many :authority_role_relationships
  has_many :authority_roles, through: :authority_role_relationships,
                             source: :authority_role

  belongs_to :manager, class_name: "AllianceCompany::User", foreign_key: :manager_id

  has_many :intentions, as: :creator
  has_many :intentions, foreign_key: :alliance_assignee_id
  has_many :customers, foreign_key: :alliance_user_id
  # validations ...............................................................
  validates :phone,
            uniqueness_without_deleted: true, presence: true
  validates :username,
            uniqueness_without_deleted: true, if: :username
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................

  enumerize :state, in: %w(enabled disabled), predicates: true

  acts_as_paranoid
  has_secure_password
  # class methods .............................................................
  class << self
    def authorities_hash
      YAML.load_file("#{Rails.root}/config/alliance_authorities.yml")
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
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  def company
    alliance_company
  end

  def can?(*actions)
    (actions - authorities).empty?
  end

  def token
    generate_token(
      user_id: id,
      settings: settings,
      password_digest: password_digest,
      authorities: Digest::MD5.hexdigest(authorities.to_json)
    )
  end

  def current_company_users
    self.class.where(company_id: company_id)
  end

  def simple_token
    generate_token(user_id: id)
  end

  def cache_uuid
    "#{id}:#{updated_at.to_i}"
  end

  def qrcode_url
    nil
  end

  def self_description
    nil
  end

  private

  def generate_token(payload)
    jwt = JWT.encode payload, Rails.application.secrets[:secret_token], "HS256"

    "AutobotsAuth #{jwt}"
  end
end
