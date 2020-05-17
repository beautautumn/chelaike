class EasyLoan::CompaniesController < EasyLoan::ApplicationController
  before_action :set_bill, only: [:update]

  # 显示公司详情
  def show
    company = Company.find(params[:id])

    render json: company,
           serializer: CompanySerializer::WithDebit,
           root: "data"
  end
end
