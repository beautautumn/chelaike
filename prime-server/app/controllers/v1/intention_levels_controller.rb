module V1
  class IntentionLevelsController < ApplicationController
    before_action do
      authorize IntentionLevel
    end

    def index
      render json: intention_level_scope.order(id: :desc),
             each_serializer: IntentionLevelSerializer::Common,
             root: "data"
    end

    def create
      intention_level = intention_level_scope.create(intention_level_params)

      if intention_level.errors.empty?
        render json: intention_level,
               serializer: IntentionLevelSerializer::Common,
               root: "data"
      else
        validation_error(full_errors(intention_level))
      end
    end

    def update
      intention_level = intention_level_scope.find(params[:id])
      intention_level.update(intention_level_params)

      if intention_level.errors.empty?
        render json: intention_level,
               serializer: IntentionLevelSerializer::Common,
               root: "data"
      else
        validation_error(full_errors(intention_level))
      end
    end

    def destroy
      render json: intention_level_scope.find(params[:id]).destroy,
             serializer: IntentionLevelSerializer::Common,
             root: "data"
    end

    private

    def intention_level_params
      params.require(:intention_level).permit(:name, :time_limitation, :company_type)
    end

    def intention_level_scope
      IntentionLevel.where(company_id: current_user.company_id).order(:time_limitation)
    end
  end
end
