module Open
  module V1
    class ServiceAppointmentsController < Open::ApplicationController
      def new
        service_appointment = current_company.service_appointments
                                             .create(service_appointment_params)

        if service_appointment.errors.empty?
          render json: { data: { id: service_appointment.id } }, scope: nil
        else
          validation_error(full_errors(service_appointment))
        end
      end

      private

      def service_appointment_params
        params.require(:service_appointment).permit(
          :service_appointment_type, :customer_name, :customer_phone, :note
        )
      end
    end
  end
end
