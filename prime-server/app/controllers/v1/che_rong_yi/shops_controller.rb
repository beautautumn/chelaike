# 新版车融易，车商相关信息接口
module V1
  module CheRongYi
    class ShopsController < ApplicationController
      before_action do
        authorize Shop
      end

      # 检查车商授信情况
      def check_accredited
        accredited_records = ::CheRongYi::Api.loan_accredited_records(current_user.company_id)

        if accredited_records.blank?
          contact_phone = EasyLoan::Setting.first.try(:phone)
          error_message = "贵公司尚未申请库融授信，请联系车来客客服！联系电话：#{contact_phone}"
          render json: { data: { state: false, message: error_message, phone: contact_phone } },
                 scope: nil
        else
          render json: { data: { state: true } }, scope: nil
        end
      end
    end
  end
end
