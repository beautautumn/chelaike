module V1
  class RegistrationsController < ApplicationController
    serialization_scope :anonymous

    skip_before_action :authenticate_user!
    before_action :skip_authorization

    def create
      registration_service = User::RegistrationService.new(user_params, company_params)
                                                      .execute(request.headers)
      @owner = registration_service.owner

      if registration_service.valid?
        render json: @owner, serializer: RegistrationSerializer::Common, root: "data"
      else
        validation_error(registration_service.errors)
      end
    end

    private

    def user_params
      params.require(:user).permit(:password, :name, :phone)
    end

    def company_params
      params.require(:company)
            .permit(:name, :province, :city, :district, :note, :contact)
    end
  end
end
