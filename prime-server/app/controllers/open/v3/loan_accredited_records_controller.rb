# 车容易授信记录调整，发送通知
module Open
  module V3
    class LoanAccreditedRecordsController < V3::ApplicationController
      # 授信调整后通知
      def notify
        service = OperationRecord::CreateService.new(nil)

        accredited_record = CheRongYi::LoanAccreditedRecord.new(accredited_record_params)
        service.che_rong_yi_accredited_updated_record(accredited_record)

        render json: { data: "", message: "success" }, scope: nil
      end

      private

      def accredited_record_params
        params.require(:loan_accredited_record).permit(
          :id, :debtor_id, :allow_part_repay, :limit_amount_cents,
          :in_use_amount_cents, :funder_company_id, :created_at,
          :updated_at, :single_car_rate, :sp_company_id,
          :limit_amount_wan, :in_use_amount_wan,
          :funder_company_name, :latest_limit_amout_wan
        )
      end
    end
  end
end
