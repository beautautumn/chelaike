class V1::IntentionExpirationsController < ApplicationController
  before_action do
    authorize IntentionExpiration
  end

  def show
    intention_expiration_scope = IntentionExpiration.where(company_id: current_user.company_id)
                                                    .first

    return render(json: { data: {} }, scope: nil) if intention_expiration_scope.blank?

    render json: intention_expiration_scope,
           serializer: IntentionExpirationSerializer::Common,
           root: "data"
  end

  def update
    intention_expiration = IntentionExpiration.find_or_create_by(
      company_id: current_user.company_id)

    if params[:intention_expiration].blank? ||
       (params[:intention_expiration] && params[:intention_expiration][:recovery_time].blank?)
      intention_expiration.destroy
      render(json: { data: {} }, scope: nil)
    else
      intention_expiration.update(intention_expiration_params)
      if intention_expiration.errors.empty?
        render json: intention_expiration,
               serializer: IntentionExpirationSerializer::Common,
               root: "data"
      else
        validation_error(full_errors(intention_expiration))
      end
    end
  end

  private

  def intention_expiration_params
    params.require(:intention_expiration).permit(
      :recovery_time, :note
    ).tap do |white_listed|
      white_listed[:recovery_hour] = white_listed[:recovery_time]
    end
  end
end
