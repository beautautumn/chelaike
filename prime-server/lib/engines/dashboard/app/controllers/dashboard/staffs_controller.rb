module Dashboard
  class StaffsController < ApplicationController
    before_action :find_staff, only: [:edit, :update]
    before_action do
      authorize Staff
    end

    def index
      @staffs = Staff.includes(:manager)
                     .where(state:"enabled")
                     .ransack(params[:q])
                     .result
                     .page(params[:page])
                     .per(20)
      @counter = Staff.where(state:"enabled")
                     .ransack(params[:q]).result.count
    end

    def create
      Staff.create(staff_params)
      redirect_to staffs_path, status: 303
    end

    def destroy
      Staff.find(params[:id]).destroy!
      redirect_to staffs_path, status: 303
    end


    def edit
      @staff
    end

    def update
      @staff.update(staff_params)

      redirect_to staffs_path, status: 303
    end

    private

    def find_staff
      @staff = Staff.find(params[:id])
    end

    def staff_params
      params.require(:staff).permit(:phone, :name, :state, :manager_id, :role)
    end
  end
end
