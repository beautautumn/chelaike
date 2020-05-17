module V1
  class IntentionPushHistoriesController < ApplicationController
    before_action :skip_authorization, only: :index

    def index
      intention_push_histories = IntentionPushHistory
                                 .where(intention_id: params[:intention_id])
                                 .includes(:intention_level, :executor, cars: [:cover])

      render json: intention_push_histories,
             each_serializer: IntentionPushHistorySerializer::Common,
             root: "data"
    end

    def create
      intention = Intention.find(params[:intention_id])
      authorize intention, :create_push_history?

      begin
        service = IntentionPushHistory::CreateService
                  .new(
                    current_user, intention,
                    intention_push_history_params(intention)
                  ).execute
      rescue Intention::CheckService::InvalidError => e
        return forbidden_error(e.message)
      end

      if service.valid?
        render json: service.intention_push_history,
               serializer: IntentionPushHistorySerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    private

    def intention_push_history_params(intention)
      if intention.intention_type.seek?
        params.require(:intention_push_history).permit(
          :state, :interviewed_time, :processing_time, :checked, :note,
          :intention_level_id, :deposit_wan, :closing_cost_wan,
          :intention_push_fail_reason_id,
          :closing_car_id, :closing_car_name, car_ids: []
        ).tap do |hash|
          hash[:car_ids] = [] unless hash[:car_ids].present?
        end
      else
        params.require(:intention_push_history).permit(
          :state, :interviewed_time, :processing_time, :checked, :note,
          :intention_level_id, :estimated_price_wan, :deposit_wan,
          :closing_cost_wan, :closing_car_id, :closing_car_name,
          :intention_push_fail_reason_id
        )
      end
    end
  end
end
