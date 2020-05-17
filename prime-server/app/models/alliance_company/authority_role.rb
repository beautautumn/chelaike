# == Schema Information
#
# Table name: alliance_authority_roles # 联盟公司的权限角色
#
#  id                  :integer          not null, primary key    # 联盟公司的权限角色
#  alliance_company_id :integer
#  name                :string                                    # 名称
#  authorities         :text             default([]), is an Array # 权限
#  note                :text                                      # 备注
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class AllianceCompany::AuthorityRole < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :alliance_company, class_name: "AllianceCompany::Company"

  has_many :alliance_authority_role_relationships,
           class_name: "AllianceCompany::AuthorityRoleRelationship",
           dependent: :delete_all
  has_many :alliance_users, class_name: "AllianceCompany::User",
                            through: :alliance_authority_role_relationships,
                            source: :user
  # validations ...............................................................
  validates :name, presence: true, uniqueness: { scope: :alliance_company_id }
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  class << self
    def find_or_create_super_manager(company_id)
      company_id.is_a?(AllianceCompany::Company) &&
        company_id = company_id.id

      find_or_create_by(alliance_company_id: company_id,
                        name: "超级管理员") do |role|
        role.note = "超级管理员，管理所有联盟后台事务"
        role.authorities = super_man_authorities
      end
    end

    def super_man_authorities
      authority_roles = YAML.load_file("#{Rails.root}/config/alliance_authorities.yml").values
      authority_roles.map(&:keys).flatten
    end
  end

  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
