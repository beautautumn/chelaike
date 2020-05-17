module V1
  class MortgageCompaniesController < ApplicationController
    before_action do
      authorize MortgageCompany
    end

    def index
      render json: mortgage_company_scope.order(id: :desc),
             each_serializer: MortgageCompanySerializer::Common,
             root: "data"
    end

    def create
      mortgage_company = mortgage_company_scope
                         .create(mortgage_company_params)

      if mortgage_company.errors.empty?
        render json: mortgage_company,
               serializer: MortgageCompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(mortgage_company))
      end
    end

    def update
      mortgage_company = mortgage_company_scope.find(params[:id])
      mortgage_company.update(mortgage_company_params)

      if mortgage_company.errors.empty?
        render json: mortgage_company,
               serializer: MortgageCompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(mortgage_company))
      end
    end

    def destroy
      render json: mortgage_company_scope.find(params[:id]).destroy,
             serializer: MortgageCompanySerializer::Common,
             root: "data"
    end

    private

    def mortgage_company_params
      params.require(:mortgage_company).permit(:name)
    end

    def mortgage_company_scope
      MortgageCompany.where(company_id: current_user.company_id)
    end
  end
end
