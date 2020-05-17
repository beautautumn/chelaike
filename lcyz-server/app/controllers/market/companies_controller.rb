module Market
  class CompaniesController < ApplicationController
    before_action :skip_authorization

    def update
      Company.find(current_user.company_id).update_columns(company_params)

      render json: { data: :ok }, scope: nil
    end

    def sync_cars
      company = Company.find(current_user.company_id)

      passport = passport(company.id)

      if RedisClient.current.get(passport).blank?
        RedisClient.current.set passport, 1, ex: 2.minutes
        MarketERPSyncWorker.perform_async(company.id)

        render json: { message: :ok }, scope: nil
      else
        forbidden_error("2分钟只能执行一次")
      end
    end

    private

    def company_params
      params.require(:company).permit(:erp_id, :erp_url)
    end

    def passport(company_id)
      "erp:sync_cars:#{company_id}"
    end
  end
end
