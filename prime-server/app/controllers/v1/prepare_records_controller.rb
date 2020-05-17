module V1
  class PrepareRecordsController < ApplicationController
    before_action only: :index do
      authorize PrepareRecord
    end

    before_action :find_prepare_record, except: :index

    def index
      basic_params_validations
      param! :order_field, String,
             default: "id",
             in: %w(
               id stock_age_days show_price_cents age
               mileage name_pinyin acquired_at stock_out_at
             )

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

      record_recent_keywords(:prepare_records)
      scope = Car.where(company_id: current_user.company_id)
      cars = paginate policy_scope(scope)
             .state_in_stock_scope
             .includes(
               { prepare_record: [:preparer, :prepare_items] },
               :acquisition_transfer, :shop, :acquirer, :cover
             ).ransack(params[:query]).result
             .order("cars.#{params[:order_field]} #{order_by}")
             .order(id: :desc)

      render json: cars,
             each_serializer: CarSerializer::PrepareRecordList,
             root: "data",
             include: [
               "acquisition_transfer", "prepare_record", "prepare_record.preparer",
               "shop", "acquirer", "cover"
             ]
    end

    def show
      render json: @prepare_record,
             serializer: PrepareRecordSerializer::Common,
             root: "data"
    end

    def update
      service = Car::UpdatePrepareRecordService.new(
        current_user, @car, @prepare_record, prepare_record_params
      )

      service.execute

      if service.errors.empty?
        render json: service.prepare_record,
               serializer: PrepareRecordSerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    private

    def prepare_record_params
      params.require(:prepare_record).permit(
        :state, :repair_state, :note, :preparer_id, :estimated_completed_at,
        :total_amount_yuan, :start_at, :end_at,
        prepare_items_attributes: [
          :id, :name, :amount_yuan, :note, :_destroy
        ]
      )
    end

    def find_prepare_record
      @car = Car.where(company_id: current_user.company_id).find(params[:car_id])

      @prepare_record = @car.prepare_record

      authorize @prepare_record
    end
  end
end
