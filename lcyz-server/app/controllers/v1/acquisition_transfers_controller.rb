module V1
  class AcquisitionTransfersController < ApplicationController
    before_action only: :index do
      authorize TransferRecord
    end

    before_action :find_acquisition_transfer, except: :index

    def index
      basic_params_validations
      param! :order_field, String,
             default: "id",
             in: %w(
               id stock_age_days show_price_cents age
               mileage name_pinyin acquired_at stock_out_at
             )

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

      record_recent_keywords(:acquisition_transfers)
      scope = Car.where(company_id: current_user.company_id)
      cars = paginate policy_scope(scope)
             .state_in_stock_scope
             .includes(
               { acquisition_transfer: [:images] }, :sale_transfer, :shop, :acquirer, :cover
             ).ransack(params[:query]).result
             .order("cars.#{params[:order_field]} #{order_by}")
             .order(id: :desc)

      render json: cars,
             each_serializer: CarSerializer::AcquisitionTransferList,
             root: "data",
             include: ["acquisition_transfer.images", "sale_transfer", "shop", "acquirer", "cover"]
    end

    def update
      authorize @acquisition_transfer
      @acquisition_transfer.update(acquisition_transfer_params)
      @car.notify_market_erp

      if @acquisition_transfer.errors.empty?
        render json: @acquisition_transfer,
               serializer: TransferRecordSerializer::Acquisition,
               root: "data"
      else
        validation_error(full_errors(@acquisition_transfer))
      end
    end

    private

    def find_acquisition_transfer
      @car = Car.where(company_id: current_user.company_id).find(params[:car_id])

      @acquisition_transfer = @car.acquisition_transfer
    end

    def acquisition_transfer_params
      # 防止空数组变成nil
      if params[:acquisition_transfer] && params[:acquisition_transfer].key?(:items)
        params[:acquisition_transfer][:items] ||= []
      end

      params.require(:acquisition_transfer).permit(
        :state, :transferred_at, { items: [] }, :contact_person, :contact_mobile,
        :original_location_province, :original_location_city, :vin,
        :original_plate_number, :original_owner,
        :original_owner_idcard, :original_owner_contact_mobile,
        :key_count, :environment_mark, :usage_type,
        :registration_number, :engine_number, :transfer_count,
        :allowed_passengers_count, :current_plate_number,
        :transfer_recevier, :transfer_recevier_idcard,
        :estimated_archived_at, :archive_fee_yuan,
        :estimated_transferred_at, :transfer_fee_yuan, :total_transfer_fee_yuan,
        :user_id, :inspection_state, :compulsory_insurance_end_at,
        :annual_inspection_end_at, :commercial_insurance_end_at,
        :commercial_insurance_amount_yuan, :note, :commercial_insurance,
        :compulsory_insurance, images_attributes: [
          :id, :url, :location, :sort, :is_cover, :_destroy
        ]
      )
    end
  end
end
