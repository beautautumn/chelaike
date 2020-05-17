# == Schema Information
#
# Table name: easy_loan_users # 车融易用户模型
#
#  id                          :integer          not null, primary key    # 车融易用户模型
#  phone                       :string                                    # 手机号码
#  token                       :string                                    # 验证码
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  expired_at                  :datetime                                  # 短信验证码失效时间
#  current_device_number       :string                                    # 车融易当前登录设备号码
#  name                        :string                                    # 车融易用户姓名
#  easy_loan_sp_company_id     :integer                                   # 所属sp公司
#  authorities                 :text             default([]), is an Array # 权限清单
#  city                        :text                                      # 员工所属地区
#  status                      :boolean          default(TRUE)            # 员工状态
#  easy_loan_authority_role_id :integer                                   # 角色关联
#  rc_token                    :string                                    # 融云token
#

class EasyLoan::User < ActiveRecord::Base
  class TokenExpired < StandardError; end # 短信失效
  class Unauthorized < StandardError; end # 鉴权失败
  class SingleLoginError < StandardError; end # 单点登录

  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :sp_company, class_name: "EasyLoan::SpCompany", foreign_key: :easy_loan_sp_company_id
  # validations ...............................................................
  belongs_to :authority_role,
             class_name: "EasyLoan::AuthorityRole",
             foreign_key: :easy_loan_authority_role_id
  has_many :messages, class_name: "EasyLoan::Message"
  has_many :operation_records, through: :messages

  validates :phone, presence: true, length: { is: 11 }, uniqueness: true
  validates :name, presence: true
  # callbacks .................................................................
  before_save :check_name_avatar
  after_commit :refresh_rongcloud, on: :update
  before_create :association_role, on: :create
  # scopes ....................................................................
  scope :sp_company_users, ->(sp_company_id) { where(easy_loan_sp_company_id: sp_company_id) }
  # additional config .........................................................
  # class methods .............................................................

  class << self
    def authorities
      YAML.load_file("#{Rails.root}/config/easy_loan_authorities.yml").inject([]) do |array, (k, _)|
        array << k
      end
    end
  end

  def jwt_token
    payload = {
      phone: phone,
      current_device_number: current_device_number
    }
    jwt = JWT.encode payload, Rails.application.secrets[:secret_token], "HS256"

    "AutobotsAuth #{jwt}"
  end

  def username
    name
  end

  def avatar
    ""
  end

  def can?(*actions)
    (actions - authorities).empty?
  end

  def city
    self[:city] || ""
  end

  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def check_name_avatar
    @_tobe_refresh = name_changed?
    true
  end

  def refresh_rongcloud
    return unless @_tobe_refresh

    service = ChatService::User.new(self, :easy_loan)
    service.refresh
  end

  def association_role
    self.authorities = self.authority_role.authorities if self.authority_role.present?
  end
end
