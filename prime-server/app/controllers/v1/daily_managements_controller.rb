module V1
  class DailyManagementsController < ApplicationController
    before_action :skip_authorization

    def show
      render json: { data: DailyManagement::BaseService.new(current_user).execute }, scope: nil
    end

    def unread
      response_data = {
        data: {
          unread: DailyManagement::BaseService.new(current_user).unread?
        }
      }

      render json: response_data, scope: nil
    end
  end
end
