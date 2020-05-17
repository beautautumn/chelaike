module V1
  class LoanBillsController < ApplicationController
    before_action do
      authorize EasyLoan::LoanBill
    end

    def index
      basic_params_validations
      bills_scope = current_user.company.loan_bills.order(created_at: :desc)
      bills = paginate bills_scope.ransack(params[:query]).result

      render json: bills,
             each_serializer: EasyLoan::LoanBillSerializer::Basic,
             root: "data"
    end

    def create
      loan_bill = EasyLoan::LoanBill.new(loan_bill_params)
      service = EasyLoanService::LoanBill.new(current_user, loan_bill)
      loan_bill = service.create

      render json: loan_bill,
             serializer: EasyLoan::LoanBillSerializer::Basic,
             root: "data"
    end

    def show
      loan_bill = EasyLoan::LoanBill.includes(:loan_bill_histories)
                                    .find(params[:id])

      render json: loan_bill,
             serializer: EasyLoan::LoanBillSerializer::Detail,
             root: "data"
    end

    def return_apply
      loan_bill_id = params[:id]

      loan_bill = EasyLoan::LoanBill.find(loan_bill_id)
      service = EasyLoanService::LoanBill.new(current_user, loan_bill)
      loan_bill = service.return_apply!

      render json: loan_bill,
             serializer: EasyLoan::LoanBillSerializer::Basic,
             root: "data"
    end

    def update
    end

    # 检查车辆信息情况
    def check_accredited
      replaced_car_ids = params[:replaced_car_ids] # 将被替换下去的车辆ID
      check_service = ::CheRongYi::CheckAccreditedService.new(params[:car_ids])
      check_result = check_service.check(replaced_car_ids)

      case check_result[:state]
      when "duplicate"
        render json: { meta: { state: "duplicate" }, data: { message: check_result[:message] } }
      when "error"
        render json: { meta: { state: "error" }, data: { message: check_result[:message] } }
      when "success"
        render json: { meta: { state: "success" }, data: nil }
      end
    end

    private

    def loan_bill_params
      params.require(:loan_bill).permit(:car_id, :funder_company_id)
    end

    def check_car_info(car_id)
      car = Car.find(car_id)

      return { state: "duplicate", message: "该车已经申请融资，不能重复申请" } if car.loan_bill.present?

      transfer_record = car.acquisition_transfer

      return { state: "error", messages: "error" } unless transfer_record

      vin_error_message = check_vin(car)

      images_error_message = check_images(transfer_record)

      key_count_message = check_key_count(transfer_record)

      error_messages = [images_error_message, key_count_message, vin_error_message].flatten

      state = error_messages.map { |m| m.fetch(:state) }.inject(true) do |acc, bool|
        bool && acc
      end

      if state
        { state: "success", message: "" }
      else
        { state: "error", message: error_messages }
      end
    end

    def check_vin(car)
      vin = car.vin
      [{ item: "车架号正确", state: vin.present?, message: vin }]
    end

    def check_key_count(transfer_record)
      key_count = transfer_record.key_count || 0
      state = key_count.try(:>, 1)
      message = state ? "" : "当前钥匙只有#{key_count}把"

      [{ item: "钥匙≥2", state: state, message: message }]
    end

    def check_images(transfer_record)
      image_locations_hash = {
        driving_license: "行驶证",
        registration_license: "登记证",
        insurance: "保单"
      }

      image_locations_hash.inject([]) do |acc, image_location_arr|
        location = image_location_arr.first
        location_text = image_location_arr.last
        image_exists = transfer_record.images.exists?(location: [location.to_s, location_text])
        error_message = image_exists ? "" : "#{location_text}照片未上传"
        acc << { item: "#{location_text}照片", state: image_exists, message: error_message }
      end
    end
  end
end
