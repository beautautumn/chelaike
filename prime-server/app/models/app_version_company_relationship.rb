# == Schema Information
#
# Table name: app_version_company_relationships # app版本公司关系表
#
#  id         :integer          not null, primary key # app版本公司关系表
#  company_id :integer                                # 公司ID
#  version_id :integer                                # 版本控制ID
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AppVersionCompanyRelationship < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  belongs_to :app_version, foreign_key: :version_id
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
