# rubocop:disable Metrics/LineLength
class TaskStatistic < ActiveRecord::Base
  class Service
    def initialize(users)
      @users = users
      @user_ids = users.map(&:id)

      @now = Time.zone.now
      @beginning_of_day = @now.beginning_of_day
      @end_of_day = @now.end_of_day
      @beginning_of_month = @now.beginning_of_month
      @end_of_month = @now.end_of_month
    end

    def uuid
      @_uuid ||= Digest::MD5.hexdigest(
        @users.map { |user| [user.id, user.updated_at] }.sort_by! { |arr| arr[0] }.to_s
      )
    end

    def cached(key)
      Rails.cache.fetch("#{self.class.name}:#{key}:#{uuid}") { yield }
    end

    def tasks_today
      cached(:tasks_today) do
        {
          pending_interviewing_task_count_today: pending_interviewing_task_count_today,
          pending_processing_task_count_today: pending_processing_task_count_today,
          expired_interviewed_task_count_today: expired_interviewed_task_count_today,
          expired_processed_task_count_today: expired_processed_task_count_today,

          pending_interviewing_finished_count_today: task_fetch_today(:pending_interviewing_finished).size,
          pending_processing_finished_count_today: task_fetch_today(:pending_processing_finished).size,
          expired_interviewed_finished_count_today: task_fetch_today(:expired_interviewed_finished).size,
          expired_processed_finished_count_today: task_fetch_today(:expired_processed_finished).size
        }.tap do |hash|
          TaskStatistic::PAST_COLUMNS.each do |column, array|
            key = "#{column}_count_today".to_sym
            hash[key] = task_fetch_today(*array).size
          end
        end
      end
    end

    def seek_task_statistic
      seek_task_today.merge(seek_task_current_month)
    end

    def sale_task_statistic
      sale_task_today.merge(sale_task_current_month)
    end

    def seek_task_today
      cached(:seek_task_today) do
        {}.tap do |hash|
          TaskStatistic::PAST_COLUMNS.each do |column, array|
            key = "#{column}_count_today".to_sym
            hash[key] = seek_intentions_today_by(*array).size
          end
        end
      end
    end

    def sale_task_today
      cached(:sale_task_today) do
        {}.tap do |hash|
          TaskStatistic::PAST_COLUMNS.each do |column, array|
            key = "#{column}_count_today".to_sym

            hash[key] = sale_intentions_today_by(*array).size
          end
        end
      end
    end

    def seek_task_current_month
      cached(:seek_task_current_month) do
        {}.tap do |hash|
          TaskStatistic::PAST_COLUMNS.each do |column, array|
            key = "#{column}_count_current_month".to_sym

            hash[key] = seek_intentions_current_month_by(*array).size
          end
        end
      end
    end

    def sale_task_current_month
      cached(:sale_task_current_month) do
        {}.tap do |hash|
          TaskStatistic::PAST_COLUMNS.each do |column, array|
            key = "#{column}_count_current_month".to_sym

            hash[key] = sale_intentions_current_month_by(*array).size
          end
        end
      end
    end

    def seek_intentions_today_by(*columns)
      intentions_by(task_statistic_today, "seek", columns)
    end

    def sale_intentions_today_by(*columns)
      intentions_by(task_statistic_today, "sale", columns)
    end

    def seek_intentions_current_month_by(*columns)
      intentions_by(task_statistic_current_month, "seek", columns)
    end

    def sale_intentions_current_month_by(*columns)
      intentions_by(task_statistic_current_month, "sale", columns)
    end

    def intentions_by(task_statistic, intention_type, columns)
      Intention.where(
        id: task_fetch(task_statistic, columns),
        intention_type: intention_type
      ).with_customer
    end

    def task_statistic_today
      task_statistic_by_date_range(:today)
    end

    def task_statistic_current_month
      task_statistic_by_date_range(:current_month)
    end

    def task_statistic_result
      {
        intention_interviewed: [],
        intention_processed: [],
        intention_completed: [],
        intention_failed: [],
        pending_interviewing_finished: [],
        pending_processing_finished: [],
        expired_interviewed_finished: [],
        expired_processed_finished: [],
        intention_invalid: []
      }
    end

    def task_fetch_today(*keys)
      task_fetch(task_statistic_today, keys)
    end

    def task_fetch_current_month(*keys)
      task_fetch(task_statistic_current_month, keys)
    end

    def task_fetch(task_statistic, keys)
      keys.each_with_object([]) do |key, acc|
        acc << task_statistic.fetch(key)
      end.flatten.uniq
    end

    def self.detail(intention_scope, user_ids, params)
      if params[:task_statistic_intention_type].present?
        intention_scope = intention_scope.where(
          intention_type: params[:task_statistic_intention_type]
        )
      end

      intention_scope.where(
        id: TaskStatistic.ids(
          TaskStatistic.past_column(params[:task_statistic_type]),
          user_ids,
          params[:task_statistic_scope]
        )
      )
    end

    private

    # 今日待接待
    def pending_interviewing_task_count_today
      scope.pending_interviewing(@now, @end_of_day).size
    end

    # 今日待跟进
    def pending_processing_task_count_today
      scope.pending_processing(@beginning_of_day, @end_of_day).size
    end

    # 过期未接待
    def expired_interviewed_task_count_today
      scope.expired_interviewed(@now).size
    end

    # 过期未跟进
    def expired_processed_task_count_today
      scope.expired_processed(@beginning_of_day).size
    end

    def scope
      Intention.with_customer.where(assignee_id: @user_ids)
    end

    def task_statistic_by_date_range(date_range)
      cached("task_statistic_#{date_range}") do
        task_statistic_result.tap do |hash|
          calculate_columns(
            TaskStatistic.where(user_id: @user_ids).send(date_range)
          ).each do |key, value|
            hash[key] = Intention.with_customer.where(id: value.flatten.uniq).pluck(:id)
          end
        end
      end
    end

    def calculate_columns(scope)
      task_statistic_result.tap do |hash|
        scope.each do |task_statistic|
          %i(
            intention_interviewed intention_processed intention_completed intention_failed
            pending_interviewing_finished pending_processing_finished expired_interviewed_finished
            expired_processed_finished intention_failed intention_invalid
          ).each do |column|
            hash[column] << task_statistic.read_attribute(column)
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/LineLength
