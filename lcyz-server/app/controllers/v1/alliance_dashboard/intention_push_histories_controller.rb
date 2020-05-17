# 联盟意向跟进历史记录
module V1
  module AllianceDashboard
    class IntentionPushHistoriesController < V1::AllianceDashboard::ApplicationController
      before_action :skip_authorization, only: :index
      before_action :find_intention

      def index
        intention_push_histories = IntentionPushHistory
                                   .where(intention_id: params[:intention_id])
                                   .includes(:intention_level, :executor, cars: [:cover])

        render json: intention_push_histories,
               each_serializer: IntentionPushHistorySerializer::Common,
               root: "data"
      end

      def create
        service = AllianceCompanyService::IntentionPushHistories::Create.new(
          current_user, @intention, intention_push_history_params
        )

        begin
          service.execute
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

      def find_intention
        @intention = Intention.find(params[:intention_id])
      end

      def intention_push_history_params
        params.require(:intention_push_history).permit(
          :state, :interviewed_time, :processing_time, :checked, :note,
          :intention_level_id, :deposit_wan, :closing_cost_wan,
          :closing_car_id, :closing_car_name, car_ids: []
        ).tap do |hash|
          hash[:car_ids] = [] unless hash[:car_ids].present?
        end
      end
    end
  end
end
