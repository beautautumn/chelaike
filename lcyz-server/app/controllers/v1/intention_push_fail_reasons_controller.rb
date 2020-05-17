module V1
  class IntentionPushFailReasonsController < ApplicationController
    before_action do
      authorize IntentionPushFailReason
    end

    def index
      fail_reasons = current_user.company.intention_push_fail_reasons

      render json: fail_reasons,
             each_serializer: IntentionPushFailReasonSerializer::Common,
             root: "data"
    end

    def create
      fail_reason = current_user.company.intention_push_fail_reasons.create!(
        fail_reason_params
      )

      render json: fail_reason,
             serializer: IntentionPushFailReasonSerializer::Common,
             root: "data"
    end

    def update
      fail_reason = IntentionPushFailReason.find(params[:id])

      fail_reason.update!(fail_reason_params)
      render json: fail_reason,
             serializer: IntentionPushFailReasonSerializer::Common,
             root: "data"
    end

    def destroy
      fail_reason = IntentionPushFailReason.find(params[:id])

      render json: fail_reason.destroy,
             serializer: IntentionPushFailReasonSerializer::Common,
             root: "data"
    end

    def app_index
      fail_reasons = current_user.company.intention_push_fail_reasons

      render json: fail_reasons,
             each_serializer: IntentionPushFailReasonSerializer::Common,
             root: "data"
    end

    private

    def fail_reason_params
      params.require(:fail_reason).permit(:id, :name, :note)
    end
  end
end
