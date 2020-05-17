module Dashboard
  class CitiesController < ApplicationController
    before_action do
      authorize :dashboard_easy_loan_setting
    end

    def index
      @cities = EasyLoan::City.ransack(params[:q])
                     .result
                     .page(params[:page])
                     .per(20)
      @counter = EasyLoan::City.ransack(params[:q]).result.count

      @q = params[:q]
    end

    def show
      @city = find_city
    end

    def update
      city = find_city
      score = params.require("city").permit(:min, :max, :utmost)
      city.update(score: score)
      redirect_to cities_path
    end

    private

    def find_city
      EasyLoan::City.find(params[:id])
    end
  end
end
