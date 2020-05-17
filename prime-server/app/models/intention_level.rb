# == Schema Information
#
# Table name: intention_levels # 意向级别
#
#  id              :integer          not null, primary key # 意向级别
#  company_id      :integer                                # 公司ID
#  name            :string                                 # 名称
#  note            :string                                 # 说明
#  deleted_at      :datetime                               # 删除时间
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  time_limitation :integer          default(0)            # 时间限制
#  company_type    :string           default("Company")    # 所属公司类型
#

class IntentionLevel < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company, polymorphic: true
  # validations ...............................................................
  validates :name,
            uniqueness_without_deleted: { scope: :company_id },
            presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  acts_as_paranoid
  # class methods .............................................................
  # public instance methods ...................................................
  def self.order_by_name
    <<-SQL.squish!
       case intention_levels.name
       when 'H' then 1
       when 'A' then 2
       when 'B' then 3
       when 'C' then 4
       when 'D' then 5
       else 100
       end
    SQL
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
