# == Schema Information
#
# Table name: customers # 客户
#
#  id                  :integer          not null, primary key     # 客户
#  company_id          :integer                                    # 公司ID
#  name                :string                                     # 姓名
#  note                :text                                       # 备注
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  phone               :string                                     # 客户主要联系电话
#  phones              :string           default([]), is an Array  # 客户联系电话
#  gender              :string                                     # 性别
#  id_number           :string                                     # 证件号
#  avatar              :string                                     # 客户头像
#  user_id             :integer                                    # 客户所属员工ID
#  first_letter        :string                                     # 客户姓名首字母
#  deleted_at          :datetime
#  source              :string           default("user_operation") # 客户产生来源
#  alliance_user_id    :integer                                    # 联盟公司员工ID
#  alliance_company_id :integer                                    # 联盟公司ID
#  memory_dates        :jsonb                                      # 纪念节日
#

class Customer < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include FirstLetter
  # relationships .............................................................
  belongs_to :company
  belongs_to :alliance_company
  belongs_to :user, -> { with_deleted }
  belongs_to :alliance_user, -> { with_deleted }
  has_many :intentions, dependent: :destroy
  # validations ...............................................................
  validate :uniqueness_in_phones_validation
  validates :phone, uniqueness: { scope: :user_id }, if: -> { user_id.present? }
  # callbacks .................................................................
  # scopes ....................................................................
  scope :intentions_state_exact_in, lambda { |*states|
    table = Intention.arel_table

    other_states = Intention.state.values - states

    exists_sql = <<-SQL.squish!
      NOT EXISTS(
        SELECT intentions.state FROM intentions
        WHERE intentions.state IN (?) AND customers.id = intentions.customer_id
      )
    SQL

    joins("FULL OUTER JOIN intentions ON intentions.customer_id = customers.id")
      .group("customers.id")
      .where(table[:state].in(states))
      .where(exists_sql, other_states)
  }

  scope :intentions_state_with_null_not_in, lambda { |*states|
    table = Intention.arel_table

    joins("FULL OUTER JOIN intentions ON intentions.customer_id = customers.id")
      .where(
        table[:state].not_in(states)
                     .or(table[:state].eq(nil))
      )
  }

  scope :follow_up, lambda {
    sql = <<-SQL
      intentions.state in ('pending', 'processing', 'interviewed',
      'reserved', 'hall_consignment', 'online_consignment')
    SQL

    joins("LEFT JOIN intentions ON customers.id = intentions.customer_id")
      .where(sql.squish)
      .uniq
  }

  scope :follows_up, lambda { |assignee_id|
    sql = <<-SQL
      intentions.state in ('pending', 'processing', 'interviewed',
      'reserved', 'hall_consignment', 'online_consignment')
      AND intentions.assignee_id = :assignee_id
    SQL

    joins("LEFT JOIN intentions ON customers.id = intentions.customer_id")
      .where(sql.squish, assignee_id: assignee_id)
      .uniq
  }

  scope :phones_include, lambda { |phone|
    sql = <<-SQL
      EXISTS (
        SELECT *
          FROM unnest(customers.phones)
          p(phone) WHERE phone LIKE :keyword
      )
      OR customers.phone LIKE :keyword
    SQL

    where(sql.squish, keyword: "#{phone}%")
  }

  scope :keyword, lambda { |k|
    sql = <<-SQL
      EXISTS (
        SELECT *
          FROM unnest(customers.phones) p(phone)
          WHERE phone LIKE :keyword
      )
      OR customers.phone LIKE :keyword
      OR customers.name LIKE :keyword
      OR customers.note LIKE :keyword
    SQL

    where(sql.squish, keyword: "%#{k}%")
      .uniq
  }

  # additional config .........................................................
  acts_as_paranoid

  enumerize :gender, in: %i(female male)
  # class methods .............................................................
  def self.ransackable_scopes(_auth_object = nil)
    %i(
      keyword phones_include
      intentions_state_with_null_not_in intentions_state_exact_in
    )
  end

  # public instance methods ...................................................
  def avatar
    self[:avatar] || FirstLetterAvatar.url(name)
  end

  def from_alliance_company?
    alliance_user_id || alliance_company_id
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def uniqueness_in_phones_validation
    conflict_customer = uniqueness_in_phones?
    return unless conflict_customer

    customer_phones = [conflict_customer.phone, *conflict_customer.phones].compact.uniq.join(" ")
    errors.add(:phone, "与客户 #{conflict_customer.name}(#{customer_phones}) 的联系电话存在冲突。")
  end

  def uniqueness_in_phones?
    input_phones = [phone, *phones].compact.uniq

    return false if input_phones.empty?

    sql = input_phones.map { |p| "'#{p}' = ANY(phones)" }.join(" OR ")
    sql << " OR phone IN (#{input_phones.map { |e| "'#{e}'" }.join(",")})"

    customers = self.class
                    .where(company_id: company_id)
                    .where(sql)
                    .where.not(id: id)

    return customers.first if customers
    false
  end
end
