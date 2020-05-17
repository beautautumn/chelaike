module V1
  class ServiceAppointmentsController < ApplicationController
    before_action :skip_authorization

    def index
      basic_params_validations
      param! :order_field, String, in: %w(id created_at updated_at), default: "id"

      service_appointments = paginate current_company_service_appointments
                             .ransack(params[:query]).result
                             .order(params[:order_field] => params[:order_by])
                             .order(:id)

      render json: service_appointments,
             each_serializer: ServiceAppointmentSerializer::Common,
             root: "data"
    end

    private

    def current_company_service_appointments
      ServiceAppointment.where(company_id: current_user.company_id)
    end
  end
end
