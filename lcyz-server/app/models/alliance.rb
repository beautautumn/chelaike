# == Schema Information
#
# Table name: alliances
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 联盟名称
#  owner_id            :integer                                # 所属公司ID
#  deleted_at          :datetime                               # 伪删除时间
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  active_tag          :boolean          default(FALSE)        # 活跃标识
#  honesty_tag         :boolean                                # 诚信标识
#  own_brand_tag       :boolean                                # 品牌商家标识
#  avatar              :string                                 # 联盟头像
#  note                :text                                   # 联盟说明
#  companies_count     :integer                                # 公司数量
#  alliance_company_id :integer                                # 外键关联联盟公司
#  convention          :text                                   # 联盟公约
#

class Alliance < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :owner, foreign_key: :owner_id, class_name: "Company"
  has_many :alliance_company_relationships, dependent: :destroy
  has_many :companies, through: :alliance_company_relationships,
                       source: :company
  # 车辆联盟展示
  has_many :all_cars, -> { uniq }, through: :companies, source: :cars
  has_many :car_alliance_blacklists, dependent: :destroy
  belongs_to :alliance_company, class_name: "AllianceCompany::Company",
                                foreign_key: :alliance_company_id

  has_many :alliance_invitations, dependent: :destroy

  has_many :cars, through: :companies, source: :cars
  has_many :users, through: :companies, source: :users
  has_many :enabled_users, -> { enabled },
           through: :companies, source: :users, class_name: User.name
  has_many :chat_groups, as: :organize, dependent: :destroy
  has_many :operation_records,
           -> { order("id desc") },
           as: :targetable
  # validations ...............................................................
  # callbacks .................................................................
  after_commit :update_chat_groups, on: :update
  # scopes ....................................................................
  scope :own_brand, -> { where(own_brand_tag: true) }
  # additional config .........................................................
  acts_as_paranoid
  # class methods .............................................................
  # public instance methods ...................................................

  def cars_count
    cars.state_in_stock_scope.where(sellable: true, reserved: false).count
  end

  def company_joined?(company_id)
    AllianceCompanyRelationship.exists?(alliance_id: id, company_id: company_id)
  end

  def allowed_cars
    all_cars.where.not(id: car_alliance_blacklists.pluck(:car_id))
  end

  def add_company(company, nickname = "")
    alliance_company_relationships.find_or_create_by(
      company_id: company.id, nickname: nickname
    )

    alliance_company.add_company(company) if alliance_company.present?
  end

  def add_companies(companies = [])
    companies.each do |company|
      add_company(company)
    end
  end

  def all_companies
    (companies + [alliance_company]).compact
  end

  def chat_groups_state
    if chat_groups.present?
      chat_groups.each_with_object({}) do |group, result|
        result[group.group_type.to_sym] = group.state
      end
    else
      { sale: "disable", acquisition: "disable" }
    end
  end

  def pending_companies
    Company.where(id: AllianceInvitation.pending.where(alliance_id: id).pluck(:company_id))
           .where.not(id: companies.pluck(:id))
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def update_chat_groups
    if chat_groups
      chat_groups.each do |group|
        group.update(
          logo: avatar
        )
      end
    end
  end
end
