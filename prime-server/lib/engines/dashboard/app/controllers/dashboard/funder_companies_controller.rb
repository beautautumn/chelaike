module Dashboard
  class FunderCompaniesController < ApplicationController
    before_action do
      authorize :dashboard_easy_loan_funder_company
    end

    before_action :find_funder_company, only: [:update, :destroy]

    def index
      @funder_companies = EasyLoan::FunderCompany.all
    end

    def create
      EasyLoan::FunderCompany.create!(
        funder_company_params
      )

      redirect_to funder_companies_path
    end

    def update
      @company.update!(funder_company_params)
      redirect_to funder_companies_path
    end

    def destroy
      @company.destroy
      redirect_to funder_companies_path
    end

    private

    def funder_company_params
      params.require(:funder_company).permit(:name)
    end

    def find_funder_company
      @company = EasyLoan::FunderCompany.find(params[:id])
    end
  end
end
