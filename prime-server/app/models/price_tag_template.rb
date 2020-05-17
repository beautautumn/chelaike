# == Schema Information
#
# Table name: price_tag_templates # 价签模板
#
#  id         :integer          not null, primary key # 价签模板
#  company_id :integer                                # 公司ID
#  name       :string                                 # 模板名称
#  code       :text                                   # 模板代码
#  backup     :string                                 # 备份地址
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  current    :boolean          default(TRUE)         # 是否当前模板
#  note       :text                                   # 说明
#

class PriceTagTemplate < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  validates :code, presence: true
  # validations ...............................................................
  # callbacks .................................................................
  before_create :set_as_current!
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_as_current!
    company.price_tag_templates.update_all(current: false)

    self.current = true
  end
end
