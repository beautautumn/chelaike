module Dashboard
  class RatingStatementsController < ApplicationController
    before_action { authorize :dashboard_easy_loan_setting }
    before_action :set_rate_statement, only: [:edit, :update]

    def index;end

    def edit;end

    def update
      @statement.update_attributes(rating_statement_params)
      redirect_to action: "index"
    end

    def rating_statement_params
      params.require(:easy_loan_rating_statement).permit(:score, :content)
    end

    private

    def set_rate_statement
      @statement = EasyLoan::RatingStatement.find(params[:id])
    end

  end
end
