module V1
  class FunderCompaniesController < ApplicationController
    before_action do
      authorize EasyLoan::FunderCompany
    end

    def index
      companies = EasyLoan::FunderCompany.all
      render json: companies,
             each_serializer: EasyLoan::FunderCompanySerializer::Basic,
             root: "data"
    end
  end
end
