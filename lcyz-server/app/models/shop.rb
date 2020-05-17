# == Schema Information
#
# Table name: shops # 店
#
#  id         :integer          not null, primary key # 店
#  name       :string                                 # 名称
#  company_id :integer                                # 所属公司
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime                               # 伪删除时间
#  address    :string                                 # 地址
#  phone      :string                                 # 联系电话
#  province   :string                                 # 所在省份
#  city       :string                                 # 所在城市
#

class Shop < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company, counter_cache: true
  has_many :cars
  has_many :users
  has_many :owner_companies

  # validations ...............................................................
  validates :name, presence: true, uniqueness_without_deleted: { scope: :company_id }
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  acts_as_paranoid
  # class methods .............................................................
  # public instance methods ...................................................
  def weshop_name
    "#{company.name}-#{name}"
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
