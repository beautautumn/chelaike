module Che3bao
  class CompaniesController < Che3bao::ApplicationController
    def index
      render json: current_company,
             serializer: CompanySerializer::Che3bao,
             root: "data"
    end
  end
end
