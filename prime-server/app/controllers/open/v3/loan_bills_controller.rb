# 车容易通知车来客库融状态发生变化
module Open
  module V3
    class LoanBillsController < V3::ApplicationController
      before_action :init_service
      # 车融易发来的通知
      def notify
        notify_type = params[:type] # loan_bill, replace_cars_bill, accredited_record, repayment_bill

        send("process_#{notify_type}")

        render json: { data: "", message: "success" }, scope: nil
      end

      private

      def process_loan_bill
        loan_bill = CheRongYi::LoanBill.new(loan_bill_params)
        @service.che_rong_yi_loan_bill_state_updated_record(loan_bill)

        # 状态为已还款时，取消车辆的限制状态
        release_states = %w(return_confirmed borrow_refused closed canceled)
        unlock_cars(loan_bill.cars) if loan_bill.state.in?(release_states)
      end

      # 处理还款单状态
      def process_repayment_bill
        loan_bill = CheRongYi::LoanBill.new(repayment_bill_params)
        @service.che_rong_yi_loan_bill_state_updated_record(loan_bill)

        # 状态为已还款时，取消车辆的限制状态
        release_states = %w(return_confirmed borrow_refused closed canceled)
        unlock_cars(loan_bill.cars) if loan_bill.state.in?(release_states)
      end

      # 处理换车单通知
      def process_replace_cars_bill
        replace_cars_bill = CheRongYi::ReplaceCarsBill.new(replace_cars_bill_params)

        @service.replace_car_state_record(replace_cars_bill)

        unlock_cars(replace_cars_bill.is_replaced_cars) if replace_cars_bill.state == "replace_confirmed"
        unlock_cars(replace_cars_bill.will_replace_cars) if replace_cars_bill.state == "replace_refused"
      end

      # 处理授信更改通知
      def process_accredited_record
        accredited_records_params = accredited_record_params[:accredited_record]
        records = accredited_records_params.map do |p|
          CheRongYi::LoanAccreditedRecord.new(p)
        end

        @service.che_rong_yi_accredited_updated_record(records)
      end

      def loan_bill_params
        params[:data].require(:loan_bill).permit(
          :id, :shop_id, :debtor_id, :sp_company_id,
          :funder_company_id, :state,
          :apply_code, :created_at, :updated_at,
          :estimate_borrow_amount_cents, :borrowed_amount_cents,
          :estimate_borrow_amount_wan,
          :borrowed_amount_wan, :remaining_amount_wan,
          :funder_company_name, :latest_history_note,
          :state_message_text,
          cars: [:id, :chelaike_car_id, :brand_name,
                 :series_name, :style_name, :company_id, :shop_id
                ]
        )
      end

      def repayment_bill_params
        params[:data].require(:repayment_bill).permit(
          :id, :shop_id, :debtor_id, :sp_company_id,
          :funder_company_id, :state,
          :apply_code, :created_at, :updated_at,
          :estimate_borrow_amount_cents, :borrowed_amount_cents,
          :estimate_borrow_amount_wan,
          :borrowed_amount_wan, :remaining_amount_wan,
          :funder_company_name, :latest_history_note,
          :state_message_text,
          cars: [:id, :chelaike_car_id, :brand_name,
                 :series_name, :style_name, :company_id, :shop_id
                ]
        )
      end

      def replace_cars_bill_params
        params[:data].require(:replace_cars_bill).permit(
          :id, :loan_bill_id, :current_amount_cents, :replace_amount_cents,
          :state, :debtor_id, :shop_id, :loan_bill_code,
          :created_at, :updated_at, :apply_code,
          :funder_company_name,
          will_replace_cars: [:id, :chelaike_car_id, :brand_name,
                              :series_name, :style_name, :company_id, :shop_id],
          is_replaced_cars: [:id, :chelaike_car_id, :brand_name,
                             :series_name, :style_name, :company_id, :shop_id],
          no_replace_cars: [:id, :chelaike_car_id, :brand_name,
                            :series_name, :style_name, :company_id, :shop_id]
        )
      end

      def accredited_record_params
        params.require(:data).permit(
          accredited_record: [
            :id, :debtor_id, :current_credit_wan,
            :funder_company_name, :latest_current_credit_wan
          ]
        )
      end

      def unlock_cars(cars)
        Car.where(id: cars.map(&:chelaike_car_id)).update_all(loan_status: :noloan, loan_bill_id: nil)
      end

      def init_service
        @service = OperationRecord::CreateService.new(nil)
      end
    end
  end
end
