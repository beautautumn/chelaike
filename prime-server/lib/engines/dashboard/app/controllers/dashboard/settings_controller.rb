module Dashboard
  class SettingsController < ApplicationController
    before_action do
      authorize :dashboard_easy_loan_setting
    end

    def show
      @setting = find_setting
    end

    def update
      setting_params = params.require(:setting).permit(
        :phone, :gross_rake, :assets_debts_rate,
        :inventory_amount, :operating_health, :industry_rating
      )
      setting = find_setting
      setting.update(setting_params)
      redirect_to setting_path
    end

    private
    def find_setting
      setting = EasyLoan::Setting.first
      setting =  EasyLoan::Setting.new unless setting
      return setting
    end

  end
end
