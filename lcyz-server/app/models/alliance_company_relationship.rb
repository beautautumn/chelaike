# == Schema Information
#
# Table name: alliance_company_relationships # 联盟公司关系表
#
#  id             :integer          not null, primary key # 联盟公司关系表
#  company_id     :integer                                # 公司ID
#  alliance_id    :integer                                # 联盟ID
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  nickname       :string                                 # 公司在联盟中的昵称
#  contact        :string                                 # 联盟联系人，联盟后台使用
#  contact_mobile :string                                 # 联盟联系电话，联盟后台使用
#  street         :string                                 # 联盟看车电话，联盟后台使用
#

class AllianceCompanyRelationship < ActiveRecord::Base
  # accessors .................................................................
  attr_readonly :alliances_count
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company, counter_cache: :alliances_count
  belongs_to :alliance, counter_cache: :companies_count
  # validations ...............................................................
  validates :company_id, presence: true,
                         uniqueness: { scope: :alliance_id }
  # callbacks .................................................................
  before_create :set_nickname
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_nickname
    self.nickname ||= company.try(:name)
  end
end
