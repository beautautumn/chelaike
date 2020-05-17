module V1
  module AllianceDashboard
    class CompaniesController < V1::AllianceDashboard::ApplicationController
      def index
        alliance = current_user.alliance_company.alliance

        companies = alliance.companies

        render json: paginate(companies),
               alliance: alliance,
               each_serializer: AllianceDashboardSerializer::CompanySerializer::Alliance,
               root: "data"
      end

      def update
        company = Company.find(params[:id])

        alliance = current_user.alliance_company.alliance

        relationship = AllianceCompanyRelationship.where(
          company_id: company.id,
          alliance_id: alliance.id).first

        relationship.update(company_params)

        if relationship.errors.empty?
          render json: company,
                 alliance: alliance,
                 serializer: AllianceDashboardSerializer::CompanySerializer::Alliance,
                 root: "data"
        else
          validation_error(full_errors(relationship))
        end
      end

      private

      def company_params
        params.require(:company).permit(
          :nickname, :contact, :contact_mobile, :street
        )
      end
    end
  end
end
