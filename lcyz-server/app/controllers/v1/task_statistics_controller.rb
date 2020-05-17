module V1
  class TaskStatisticsController < ApplicationController
    before_action :skip_authorization

    # 废弃的
    def index
      if params[:user_ids].present?
        user_ids = params[:user_ids].split(",").map(&:squish!)
        @users = User.where(id: user_ids)
      else
        @users = [current_user]
      end

      @users.each { |user| authorize user, :task_statistic? }

      render json: { data: TaskStatistic::Service.new(@users).tasks_today }, scope: nil
    end

    def show
      task_statistic = TaskStatistic::Service.new(
        User::IntentionService.related_users(current_user, shop_id: params[:shop_id])
      )

      render json: {
        meta: Time.zone.now,
        data: {
          seek_intention_tasks: task_statistic.seek_task_statistic,
          sale_intention_tasks: task_statistic.sale_task_statistic
        }
      }, scope: nil
    end
  end
end
