module EasyLoanService
  class LoanBill
    attr_accessor :user, :loan_bill

    def initialize(user, loan_bill = nil)
      @user = user
      @loan_bill = loan_bill
    end

    def create
      EasyLoan::LoanBill.transaction do
        save_loan_bill!
        record_state_history!(@loan_bill.estimate_borrow_amount_wan)
      end

      # generate_operation_record

      easy_loan_message_service = EasyLoan::OperationRecord::CreateService.new(@user)
      easy_loan_message_service.borrow_applied_record(@loan_bill)

      @loan_bill
    end

    def return_apply!
      EasyLoan::LoanBill.transaction do
        @loan_bill.update!(state: :return_applied)
        record_state_history!(@loan_bill.borrowed_amount_wan)
      end
      # generate_operation_record
      easy_loan_message_service = EasyLoan::OperationRecord::CreateService.new(@user)
      easy_loan_message_service.return_applied_record(@loan_bill)
      @loan_bill
    end

    def change_state!(state:, borrowed_amount_wan: nil, note: "")
      EasyLoan::LoanBill.transaction do
        @loan_bill.update!(state: state)
        process_borrowed_amount(state, borrowed_amount_wan)
        process_accredited_record(state)
        record_state_history!(borrowed_amount_wan, note)
      end
      generate_operation_record

      easy_loan_message_service = EasyLoan::OperationRecord::CreateService.new(@user)
      easy_loan_message_service.loan_bill_state_updated_record(@loan_bill)
      @loan_bill
    end

    # 得到所匹配的金融专员
    def matched_easy_loan_users
      company = @loan_bill.company
      user_city = "#{company.province},#{company.city}"
      users = EasyLoan::User.where(city: user_city)
      users
    end

    private

    def save_loan_bill!
      car_id = @loan_bill.car_id
      accredited_record = EasyLoan::AccreditedRecord.where(
        funder_company_id: @loan_bill.funder_company_id,
        company_id: @user.company_id
      ).first

      @loan_bill.assign_attributes(
        company_id: @user.company_id,
        sp_company_id: EasyLoan::SpCompany.first.id,
        state: :borrow_applied,
        car_basic_info: car_basic_info(car_id),
        estimate_borrow_amount_wan: Lib.estimate_car_price_wan(car_id, accredited_record)
      )

      @loan_bill.save!
      @loan_bill
    end

    def record_state_history!(amount_wan, note = "")
      # return unless @loan_bill.latest_state_history.try(:bill_state) != @loan_bill.state
      @loan_bill.loan_bill_histories.create!(
        user: @user,
        bill_state: @loan_bill.state,
        amount_wan: amount_wan,
        note: note
      )
    end

    # 生成车来客里的操作记录及相应消息
    def generate_operation_record
      service = OperationRecord::CreateService.new(@user)
      service.loan_bill_state_updated_record(@loan_bill)
    end

    def car_basic_info(car_id)
      car = Car.find(car_id)
      {
        name: car.system_name,
        vin: car.vin,
        key_count: car.acquisition_transfer.try(:key_count)
      }
    end

    def process_borrowed_amount(state, amount_wan)
      return unless state.to_s == "borrow_confirmed"
      @loan_bill.update!(borrowed_amount_wan: amount_wan)
    end

    def process_accredited_record(state)
      state = state.to_s
      return unless state.in?(%w(borrow_confirmed return_confirmed closed))
      accredited_record = EasyLoan::AccreditedRecord.where(
        company_id: @loan_bill.company_id,
        funder_company_id: @loan_bill.funder_company_id
      ).first

      amount_wan = case state
                   when "borrow_confirmed"
                     accredited_record.in_use_amount_wan + @loan_bill.borrowed_amount_wan
                   when "return_confirmed"
                     accredited_record.in_use_amount_wan - @loan_bill.borrowed_amount_wan
                   end
      accredited_record.update!(in_use_amount_wan: amount_wan)
    end
  end
end
