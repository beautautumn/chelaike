class EasyLoan::FunderCompaniesController < EasyLoan::ApplicationController
  def index
    basic_params_validations
    funder_companies = paginate EasyLoan::FunderCompany.all

    render json: funder_companies,
           each_serializer: EasyLoanSerializer::FunderCompanySerializer::Basic,
           root: "data"
  end
end
