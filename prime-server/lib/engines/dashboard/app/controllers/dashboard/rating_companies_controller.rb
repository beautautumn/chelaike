module Dashboard
  class RatingCompaniesController < ApplicationController
    before_action { authorize :dashboard_easy_loan_setting }
    before_action :set_company, only: [:edit, :update]

    def index
      @companies = Company.ransack(params[:q])
                     .result
                     .page(params[:page])
                     .per(20).order(id: :asc)
      @counter = Company.ransack(params[:q]).result.count

      @q = params[:q]
    end

    def edit;end

    def update
      ActiveRecord::Base.transaction do
        @company.update_attributes(company_params)
        @company.latest_loan_debit.update_attributes!(
          industry_rating: params[:company][:industry_rating],
          assets_debts_rating: params[:company][:assets_debts_rating]
        ) if @company.latest_loan_debit
      end
      redirect_to action: "index"
    end

    private

    def company_params
      params.require(:company).permit(:industry_rating, :assets_debts_rating)
    end

    def set_company
      @company = Company.find(params[:id])
    end
  end
end
