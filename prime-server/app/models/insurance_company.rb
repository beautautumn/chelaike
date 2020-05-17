# == Schema Information
#
# Table name: insurance_companies # 保险公司
#
#  id         :integer          not null, primary key # 保险公司
#  company_id :integer                                # 公司ID
#  name       :string                                 # 名称
#  deleted_at :datetime                               # 删除时间
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InsuranceCompany < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  has_many :stock_out_inventories
  # validations ...............................................................

  validates :name, presence: true, uniqueness_without_deleted: { scope: :company_id }
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  acts_as_paranoid
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
