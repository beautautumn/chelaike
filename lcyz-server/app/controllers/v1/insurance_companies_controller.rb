module V1
  class InsuranceCompaniesController < ApplicationController
    before_action do
      authorize InsuranceCompany
    end

    def index
      render json: insurance_company_scope.order(id: :desc),
             each_serializer: InsuranceCompanySerializer::Common,
             root: "data"
    end

    def create
      insurance_company = insurance_company_scope
                          .create(insurance_company_params)

      if insurance_company.errors.empty?
        render json: insurance_company,
               serializer: InsuranceCompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(insurance_company))
      end
    end

    def update
      insurance_company = insurance_company_scope.find(params[:id])
      insurance_company.update(insurance_company_params)

      if insurance_company.errors.empty?
        render json: insurance_company,
               serializer: InsuranceCompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(insurance_company))
      end
    end

    def destroy
      render json: insurance_company_scope.find(params[:id]).destroy,
             serializer: InsuranceCompanySerializer::Common,
             root: "data"
    end

    private

    def insurance_company_params
      params.require(:insurance_company).permit(:name)
    end

    def insurance_company_scope
      InsuranceCompany.where(company_id: current_user.company_id)
    end
  end
end
