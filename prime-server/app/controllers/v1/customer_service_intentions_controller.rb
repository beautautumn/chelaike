module V1
  class CustomerServiceIntentionsController < ApplicationController
    before_action :skip_authorization, except: [:batch_assign]

    def index
      basic_params_validations
      order_by = params[:order_by] == "asc" ? "ASC NULLS LAST" : "DESC NULLS FIRST"
      order_field = params[:order_field].blank? ? "intentions.id" : params[:order_field]

      intentions = paginate intention_scope
                   .includes(:intention_level, :channel, :assignee)
                   .ransack(params[:query]).result
                   .order("#{order_field} #{order_by}")
                   .order("intentions.id")

      render json: intentions,
             each_serializer: IntentionSerializer::Basic,
             root: "data", include: "**"
    end

    def destroy
      intention = intention_scope.find(params[:id])
      intention.destroy

      render json: { data: { id: intention.id } }, scope: nil
    end

    private

    def intention_scope
      Intention.where(
        creator_id: current_user.id,
        creator_type: "User"
      ).with_customer
    end
  end
end
