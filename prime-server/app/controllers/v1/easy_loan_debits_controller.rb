module V1
  class EasyLoanDebitsController < ApplicationController
    before_action do
      authorize EasyLoan::Debit
    end

    def index
    end

    def show
      company = current_user.company
      debit = company.latest_loan_debit

      if debit
        render json: debit,
               serializer: EasyLoan::DebitSerializer::Basic,
               root: "data"
      else
        render json: { data: { message: "暂无车融易评级数据" } }, scope: nil, status: 422
      end
    end
  end
end
