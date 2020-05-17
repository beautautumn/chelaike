module Dashboard
  class UsersController < ApplicationController
    before_action :find_user, except: :index
    before_action do
      authorize :dashboard_user
    end

    def index
      #return @users = User.none.page(0) unless search?

      @users = User.includes(:company)
                   .ransack(params[:q])
                   .result
                   .page(params[:page])
                   .per(20)
      @counter = User.ransack(params[:q]).result.count
    end

    def destroy
      User.transaction do
        record(@user)
        @user.destroy!
      end

      redirect_to users_path, status: 303
    end

    private

    def find_user
      @user = User.find(params[:id])
    end

    def record(user)
      current_staff.operation_records.create!(
        operation_type: "user_deletion",
        content: {
          company_id: user.company_id,
          company_name: user.company.name,
          user_id: user.id,
          user_name: user.name,
          user_phone: user.phone
        }
      )
    end
  end
end
