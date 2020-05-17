# == Schema Information
#
# Table name: expiration_settings # 公司设置到期提醒时间
#
#  id            :integer          not null, primary key # 公司设置到期提醒时间
#  company_id    :integer                                # 所属公司
#  notify_type   :string                                 # 提醒类型
#  first_notify  :integer                                # 首次提醒时间
#  second_notify :integer                                # 再次提醒时间
#  third_notify  :integer                                # 三次提醒时间
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ExpirationSetting < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company

  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................

  # 节日 年审 保险 按揭
  enumerize :notify_type, in: %i(memory_date annual_inspection insurance mortgage)

  # class methods .............................................................
  class << self
    def memory_date_notify_days
      { first: 0, second: nil, third: nil }
    end

    def annual_inspection_notify_days
      { first: 14, second: 7, third: 3 }
    end

    def insurance_notify_days
      { first: 30, second: 15, third: 7 }
    end

    def mortgage_notify_days
      { first: 14, second: 7, third: 3 }
    end

    def init(company)
      notify_type.values.map do |type|
        days_hash = send("#{type}_notify_days")
        company.expiration_settings.create!(
          notify_type: type,
          first_notify: days_hash.fetch(:first),
          second_notify: days_hash.fetch(:second),
          third_notify: days_hash.fetch(:third)
        )
      end
    end
  end
  # public instance methods ...................................................

  def name
    {
      memory_date: "节日提醒",
      annual_inspection: "年审提醒",
      insurance: "保险到期",
      mortgage: "按揭到期"
    }.fetch(notify_type.to_sym)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
