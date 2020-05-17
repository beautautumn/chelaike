module Dashboard
  class StatisticsController < ApplicationController
    before_action :find_company_staff_relationship, only: [:edit, :update]
    before_action :find_company, only: [:show]
    before_action do
      authorize :dashboard_statistics
    end

    def index
      @companies = policy_scope(:dashboard_statistics)
                   .ransack(params[:q])
                   .result
                   .page(params[:page])
                   .per(20)
      @counter = policy_scope(:dashboard_statistics)
                   .ransack(params[:q]).result.count
    end

    def edit
    end

    def show
      @car_data = Dw::Analysis::Car.new(params[:id])
                                   .statistic(current_year, current_month)
      @customer_data = Dw::Analysis::Customer.new(params[:id])
                                             .statistic(current_year, current_month)
      @intention_data = Dw::Analysis::Intention.new(params[:id])
                                               .statistic(current_year, current_month)
      @operation_data = Dw::Analysis::OperationRecord.new(params[:id])
                                                     .statistic(current_year, current_month)
    end

    def update
      @relationship.staff_id = params[:company_staff_relationship][:staff_id]
      @relationship.save

      redirect_to statstic_path, status: 303
    end

    private

    def find_company_staff_relationship
      @relationship = CompanyStaffRelationship.find_by(company_id: params[:id]) ||
                      CompanyStaffRelationship.new(company_id: params[:id])
    end

    def find_company
      @company = Company.find(params[:id])
    end

    def current_month
      @month = params[:month] || Time.zone.now.month
    end

    def current_year
      @year = params[:year] || Time.zone.now.year
    end
  end
end
