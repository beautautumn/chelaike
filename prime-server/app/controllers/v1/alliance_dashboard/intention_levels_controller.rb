# 联盟公司用户session管理
module V1
  module AllianceDashboard
    class IntentionLevelsController < V1::AllianceDashboard::ApplicationController
      before_action :find_company
      before_action :set_intention_level, only: [:show, :update, :destroy]

      def index
        render json: intention_level_scope.order(id: :desc),
               each_serializer: IntentionLevelSerializer::Common,
               root: "data"
      end

      def create
        intention_level = @company.intention_levels.create(intention_level_params)
        if intention_level.errors.empty?
          render json: intention_level,
                 serializer: IntentionLevelSerializer::Common,
                 root: "data"
        else
          validation_error(full_errors(intention_level))
        end
      end

      def update
        @intention_level.update_attributes(intention_level_params)
        render json: @intention_level,
               serializer: IntentionLevelSerializer::Common,
               root: "data"
      end

      def show
        render json: @intention_level,
               serializer: IntentionLevelSerializer::Common,
               root: "data"
      end

      def destroy
        @intention_level.destroy
        render json: @intention_level,
               serializer: IntentionLevelSerializer::Common,
               root: "data"
      end

      private

      def find_company
        @company = current_user.alliance_company
      end

      def set_intention_level
        @intention_level = IntentionLevel.find(params[:id])
      end

      def intention_level_params
        params.require(:intention_level).permit(:name, :time_limitation)
      end

      def intention_level_scope
        IntentionLevel.where(company_id: @company.id).order(:time_limitation)
      end
    end
  end
end
