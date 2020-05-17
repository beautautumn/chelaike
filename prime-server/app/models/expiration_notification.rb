# == Schema Information
#
# Table name: expiration_notifications # 服务到期提醒
#
#  id              :integer          not null, primary key # 服务到期提醒
#  associated_id   :integer                                # 关联记录ID
#  associated_type :string                                 # 关联记录类型
#  notify_type     :string                                 # 通知类型
#  notify_date     :date                                   # 提醒日期
#  notify_name     :string                                 # 通知的名字
#  setting_date    :date                                   # 原记录里设置的时间
#  user_id         :integer                                # 要通知到的用户
#  company_id      :integer                                # 所属公司ID
#  actived         :boolean          default(TRUE)         # 是否可用
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ExpirationNotification < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  belongs_to :associated, polymorphic: true
  belongs_to :user
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :notify_type, in: %i(memory_date annual_inspection insurance mortgage)

  # class methods .............................................................
  class << self
    def company_notify_date(company, notify_type, setting_date)
      notify_days = days_arr(company, notify_type)

      current_date = Time.zone.now.to_date
      remaing_days = (setting_date - current_date).to_i

      first_notify = notify_days.first.presence || 0

      last_notify_days = notify_days.last

      return unless last_notify_days
      return if remaing_days < 0
      if remaing_days.zero? || remaing_days <= last_notify_days
        return (setting_date - first_notify) + 1.year
      end

      day = notify_days.detect { |d| d < remaing_days }
      setting_date - day
    end

    def days_arr(company, notify_type)
      setting = company.expiration_settings.where(notify_type: notify_type).first
      [
        setting.first_notify,
        setting.second_notify,
        setting.third_notify
      ].compact
    end
  end

  # public instance methods ...................................................

  # 根据公司设置的提醒时间，更新提醒日期
  def update_notify_date!(notify_setting, new_setting_date = nil)
    raise Error if notify_setting.notify_type != notify_type

    new_setting_date ||= setting_date

    update!(
      setting_date: new_setting_date,
      notify_date: self.class.company_notify_date(company, notify_type, new_setting_date)
    )
  end

  def notify_user
    return user if notify_type == :memory_date
    associated.after_sale_assignee || associated.assignee
  end

  def notify_type_str
    {
      "memory_date" => "节日",
      "annual_inspection" => "年审",
      "insurance" => "保险",
      "mortgage" => "按揭"
    }.fetch(notify_type.to_s)
  end

  def notify_setting
    company.expiration_settings.where(notify_type: notify_type).first
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
