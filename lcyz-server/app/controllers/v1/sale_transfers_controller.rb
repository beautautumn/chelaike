module V1
  class SaleTransfersController < ApplicationController
    before_action only: :index do
      authorize TransferRecord
    end

    before_action :find_sale_transfer

    def update
      @sale_transfer.update(sale_transfer_params)

      if @sale_transfer.errors.empty?
        render json: @sale_transfer,
               serializer: TransferRecordSerializer::Acquisition,
               root: "data"
      else
        validation_error(full_errors(@sale_transfer))
      end
    end

    private

    def find_sale_transfer
      @sale_transfer = Car.where(company_id: current_user.company_id)
                          .find(params[:car_id])
                          .sale_transfer
      authorize @sale_transfer
    end

    def sale_transfer_params
      params.require(:sale_transfer).permit(
        :state, :key_count, :contact_person, :contact_mobile,
        :original_location_province, :original_location_city,
        :current_location_province, :current_location_city,
        :original_plate_number, :new_plate_number, :original_owner,
        :original_owner_idcard, :new_owner, :new_owner_idcard,
        :new_owner_contact_mobile, :user_id, :estimated_archived_at,
        :archive_fee_yuan, :estimated_transferred_at, :transferred_at,
        :transfer_fee_yuan, :total_transfer_fee_yuan, :compulsory_insurance_end_at,
        :annual_inspection_end_at, :commercial_insurance_end_at,
        :commercial_insurance_amount_yuan, :usage_type,
        :registration_number, :transfer_count, :engine_number,
        :compulsory_insurance, :commercial_insurance,
        :allowed_passengers_count, :note, :current_plate_number,
        items: []
      )
    end
  end
end
