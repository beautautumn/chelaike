module V1
  class CooperationCompaniesController < ApplicationController
    before_action do
      authorize CooperationCompany
    end

    def index
      render json: cooperation_company_scope.order(id: :desc),
             each_serializer: CooperationCompanySerializer::Common,
             root: "data"
    end

    def create
      cooperation_company = cooperation_company_scope
                            .create(cooperation_company_params)

      if cooperation_company.errors.empty?
        render json: cooperation_company,
               serializer: CooperationCompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(cooperation_company))
      end
    end

    def update
      cooperation_company = cooperation_company_scope.find(params[:id])
      cooperation_company.update(cooperation_company_params)

      if cooperation_company.errors.empty?
        render json: cooperation_company,
               serializer: CooperationCompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(cooperation_company))
      end
    end

    def destroy
      render json: cooperation_company_scope.find(params[:id]).destroy,
             serializer: CooperationCompanySerializer::Common,
             root: "data"
    end

    private

    def cooperation_company_params
      params.require(:cooperation_company).permit(:name)
    end

    def cooperation_company_scope
      CooperationCompany.where(company_id: current_user.company_id)
    end
  end
end
