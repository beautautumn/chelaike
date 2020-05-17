module V1
  class AllianceCompaniesController < ApplicationController
    before_action :find_alliance

    def index
      authorize @alliance, :companies?
      companies = paginate @alliance.companies
                  .ransack(params[:query])
                  .result
      render json: companies,
             each_serializer: CompanySerializer::Alliance,
             root: "data"
    end

    def no_allied
      authorize @alliance, :companies?
      companies = paginate Company.where.not(id: @alliance.companies)
                  .ransack(params[:query])
                  .result
      render json: companies,
             each_serializer: CompanySerializer::Alliance,
             root: "data"
    end

    def show
      authorize @alliance, :company?
      render json: @alliance.companies.find(params[:id]),
             serializer: CompanySerializer::AllianceDetail,
             root: "data"
    end

    private

    def find_alliance
      @alliance = Company.find(current_user.company_id)
                         .alliances.find(params[:alliance_id])
    end
  end
end
