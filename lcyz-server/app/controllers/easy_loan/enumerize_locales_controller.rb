module EasyLoan
  class EnumerizeLocalesController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      data = Rails.cache.fetch("EnumerizeLocales_EasyLoan") do
        { data: I18n.t("enumerize") }
      end

      render json: data, scope: nil
    end
  end
end
