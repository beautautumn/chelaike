# 车容易换车状态更新
module Open
  module V3
    class ReplaceCarsBillsController < V3::ApplicationController
      # 换车状态更新通知
      def notify
        service = OperationRecord::CreateService.new(nil)

        replace_cars_bill = CheRongYi::ReplaceCarsBill.new(replace_cars_bill_params)
        service.replace_car_state_record(replace_cars_bill)
        render json: { data: "", message: "success" }, scope: nil
      end

      private

      def replace_cars_bill_params
        params.require(:replace_cars_bill).permit(
          :id, :loan_bill_id, :current_amount_cents,
          :replace_amount_cents, :state, :debtor_id,
          :loan_bill_code, :original_cars, :new_cars
        )
      end
    end
  end
end
