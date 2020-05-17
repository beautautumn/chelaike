class OperationRecord < ActiveRecord::Base
  class CreateService
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def loan_bill_state_updated_record(loan_bill)
      class_name = loan_bill.class.name.demodulize
      return unless class_name.in?(%w(LoanBill))

      loan_bill.operation_records.create!(
        user: user,
        company_id: loan_bill.company_id,
        operation_record_type: :loan_bill_state_updated,
        shop_id: loan_bill.shop_id,
        messages: {
          loan_bill_id: loan_bill.id,
          title: "库融状态更新",
          car_name: loan_bill.car.system_name,
          bill_state: loan_bill.state,
          state_text: loan_bill.state_text,
          state_message_text: loan_bill.state_message_text,
          funder_company_name: loan_bill.funder_company.name,
          note: loan_bill.latest_state_history.try(:note)
        }
      )
    end

    def accredited_updated_record(accredited)
      accredited.operation_records.create!(
        user: user,
        company_id: accredited.company_id,
        operation_record_type: :accredited_updated,
        shop_id: accredited.shop_id,
        messages: {
          accredited_record_id: accredited.id,
          title: "授信额度调整",
          funder_company_name: accredited.funder_company_name,
          current_limit_amount_wan: accredited.limit_amount_wan,
          latest_limit_amout_wan: accredited.latest_limit_amout_wan
        }
      )
    end

    def debit_updated_record(debit)
      debit.operation_records.create!(
        user: user,
        company_id: debit.company_id,
        operation_record_type: :debit_updated,
        shop_id: debit.shop_id,
        messages: {
          debit_id: debit.id,
          title: "库融评级发布",
          comprehensive_rating: debit.comprehensive_rating,
          inventory_amount: debit.inventory_amount,
          operating_health: debit.operating_health,
          industry_rating: debit.industry_rating,
          beat_global: debit.beat_global,
          beat_local: debit.beat_local
        }
      )
    end
  end
end
