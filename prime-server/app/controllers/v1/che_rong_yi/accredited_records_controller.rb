# 新版车容易授信相关接口
module V1
  module CheRongYi
    class AccreditedRecordsController < ApplicationController
      before_action do
        authorize EasyLoan::AccreditedRecord
      end

      # 得到某车商所有的授信记录
      def index
        accredited_records = ::CheRongYi::Api.loan_accredited_records(current_user.company_id)

        total_info = accredited_records.first

        total_current_credit_wan = total_info.total_current_credit_wan
        single_car_rate = total_info.single_car_rate
        total_limit_amount_wan = accredited_records.inject(0) do |sum, a|
          sum + a.limit_amount_wan
        end

        total_in_use_amount_wan = accredited_records.inject(0) do |sum, a|
          sum + a.in_use_amount_wan
        end

        render json: accredited_records,
               each_serializer: CheRongYiSerializer::AccreditedRecordSerializer::Common,
               root: "data",
               meta: {
                 total_current_credit_wan: total_current_credit_wan, # 当前总授信
                 single_car_rate: single_car_rate, # 单车借款比例
                 total_limit_amount_wan: total_limit_amount_wan, # 总最大授信
                 total_in_use_amount_wan: total_in_use_amount_wan # 总已用额度
               }
      end

      # 得到所有给这个车商授信过的资金公司列表
      def funder_companies
        accredited_records = ::CheRongYi::Api.loan_accredited_records(current_user.company_id)

        infos = accredited_records.map do |record|
          {
            funder_company_id: record.funder_company_id, # 资金公司ID
            funder_company_name: record.funder_company_name # 资金公司名
          }
        end

        render json: { data: infos }, scope: nil
      end
    end
  end
end
