module V1
  class CarAppointmentsController < ApplicationController
    before_action :skip_authorization
    skip_before_action :authenticate_user!, only: :create

    serialization_scope :anonymous

    def create
      service = Intention::CreateService.new(
        User::Anonymous.new(company: current_company), current_company.intentions, intention_params
      )
      service.execute(check_intention: true)

      if service.valid?
        render json: { data: { id: service.intention.id } }, scope: nil
      else
        validation_error(service.errors)
      end
    end

    private

    def car_appointment_params
      params.require(:car_appointment).permit(
        :name, :phone, :car_id, :seller_id
      )
    end

    def intention_params
      scrapped_params = car_appointment_params

      {}.tap do |hash|
        hash[:customer_name] = scrapped_params[:name]
        hash[:customer_phone] = scrapped_params[:phone]
        hash[:assignee_id] = scrapped_params[:seller_id]
        hash[:intention_type] = :seek
        hash[:source] = "car_appointment"

        car_id = scrapped_params[:car_id]

        if car_id.present?
          car = Car.with_deleted.find_by(id: car_id)

          if car.present?
            hash[:intention_note] = "库存号为: #{car.stock_number}"
            hash[:seeking_cars] = [
              {
                brand_name: car.brand_name,
                series_name: car.series_name,
                style_name: car.style_name
              }
            ]
          end
        end
      end
    end

    def current_company
      Company.find(params[:company_id])
    end
  end
end
