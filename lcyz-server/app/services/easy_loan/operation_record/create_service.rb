module EasyLoan
  class OperationRecord < ActiveRecord::Base
    class CreateService
      attr_accessor :user

      def initialize(user)
        @user = user
      end

      def loan_bill_state_updated_record(loan_bill)
        latest_history = loan_bill.latest_state_history

        loan_bill.easy_loan_operation_records.create!(
          user: user,
          sp_company_id: loan_bill.sp_company_id,
          operation_record_type: :loan_bill_state_updated,
          messages: {
            loan_bill_id: loan_bill.id,
            title: "库融状态更新",
            state_text: loan_bill.state_text,
            company_id: loan_bill.company_id,
            company_name: loan_bill.company_name,
            car_name: loan_bill.car.system_name,
            amount_wan: latest_history.amount_wan,
            car_cover_url: loan_bill.car.cover_url,
            apply_code: loan_bill.apply_code
          }
        )
      end

      def borrow_applied_record(loan_bill)
        loan_bill.easy_loan_operation_records.create!(
          user: user,
          sp_company_id: loan_bill.sp_company_id,
          operation_record_type: :borrow_applied,
          messages: {
            loan_bill_id: loan_bill.id,
            title: "借款申请",
            company_name: loan_bill.company_name,
            company_id: loan_bill.company_id,
            car_name: loan_bill.car.system_name,
            amount_wan: loan_bill.estimate_borrow_amount_wan,
            car_cover_url: loan_bill.car.cover_url,
            apply_code: loan_bill.apply_code
          }
        )
      end

      def return_applied_record(loan_bill)
        latest_history = loan_bill.latest_state_history
        loan_bill.easy_loan_operation_records.create!(
          user: user,
          sp_company_id: loan_bill.sp_company_id,
          operation_record_type: :return_applied,
          messages: {
            loan_bill_id: loan_bill.id,
            title: "还款申请",
            company_id: loan_bill.company_id,
            company_name: loan_bill.company_name,
            car_name: loan_bill.car.system_name,
            amount_wan: latest_history.amount_wan,
            car_cover_url: loan_bill.car.cover_url,
            apply_code: loan_bill.apply_code
          }
        )
      end
    end
  end
end
