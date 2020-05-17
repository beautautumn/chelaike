# == Schema Information
#
# Table name: task_statistics # 任务统计
#
#  id                            :integer          not null, primary key # 任务统计
#  user_id                       :integer                                # 用户ID
#  shop_id                       :integer                                # 分店ID
#  company_id                    :integer                                # 公司ID
#  record_date                   :date                                   # 记录日期
#  intention_interviewed         :integer          is an Array           # 今日意向已接待
#  intention_processed           :integer          is an Array           # 今日意向已跟进
#  intention_completed           :integer          is an Array           # 今日意向已经成交
#  intention_failed              :integer          is an Array           # 今日意向已失败
#  intention_invalid             :integer          is an Array           # 今日意向已失效
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  pending_interviewing_finished :integer          is an Array           # 今日待接待已完成
#  pending_processing_finished   :integer          is an Array           # 今日待跟进已完成
#  expired_interviewed_finished  :integer          is an Array           # 过期未接待已完成
#  expired_processed_finished    :integer          is an Array           # 过期未跟进已完成
#

class TaskStatistic < ActiveRecord::Base
  RECORD_COLUMNS = %w(
    intention_interviewed intention_processed intention_completed
    intention_failed intention_invalid
    pending_interviewing_finished pending_processing_finished
    expired_interviewed_finished expired_processed_finished
  ).freeze

  PAST_COLUMNS = {
    intention_interviewed: [:intention_interviewed],
    intention_processed: [:intention_processed],
    intention_completed: [:intention_completed],
    intention_failed: [:intention_failed, :intention_invalid]
  }.with_indifferent_access

  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :user
  belongs_to :company
  # validations ...............................................................
  validates :user_id, presence: true
  validates :company_id, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :today, -> { where(record_date: Time.zone.today) }
  scope :current_month, lambda {
    where(
      "record_date >= ? AND record_date <= ?",
      Time.zone.now.beginning_of_month, Time.zone.now.end_of_month
    )
  }
  # additional config .........................................................
  # class methods .............................................................
  def self.increment(column, user, intention_id, record_date = Time.zone.today)
    TaskStatistic.transaction do
      task_statistic = TaskStatistic.find_or_initialize_by(
        company_id: user.company_id,
        user_id: user.id,
        record_date: record_date
      )

      value = (task_statistic.send(column) || []).push(intention_id).uniq

      task_statistic.assign_attributes(column => value)
      task_statistic.save!
    end
  end

  def self.ids(columns, user_ids, scope = :today)
    send(scope)
      .where(user_id: user_ids)
      .map { |t| columns.map { |column| t.read_attribute(column) } }
      .flatten.compact.uniq
  end

  def self.past_column(column)
    PAST_COLUMNS.fetch(column)
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
