class EasyLoan::SessionsController < EasyLoan::ApplicationController
  skip_before_action :authenticate_user!, only: [:code, :create]
  def code
    param! :phone_number, String, min_length: 10, required: true

    sms_object = SmsService.new(params[:phone_number])
    sms_object.send_cms

    render json: { data: { message: true } }, scope: nil, status: 200
  end

  def create
    param!  :phone_number, String, min_length: 10, required: true
    param!  :code,  String, required: true

    sms_object = SmsService.new(params[:phone_number], "verify")
    if sms_object.user.token == params[:code]
      sms_object.user.update_attributes!(current_device_number: current_device_number)
      token = payload_token

      response = {
        user_id: sms_object.user.id,
        token: "AutobotsAuth #{token}",
        name: sms_object.user.name,
        phone: sms_object.user.phone,
        authorities: sms_object.user.authorities
      }

      render json: { data: response }, status: 200, scope: nil
    else
      render json: { data: { token: nil } }, status: 400, scope: nil
    end
  end

  private

  def current_device_number
    @_current_device_number ||= (0...6).map { (0..9).to_a[rand(10)] }.join
  end

  def payload_token
    payload = {
      phone: params[:phone_number],
      current_device_number: current_device_number
    }

    Util::JwtService.encode(payload)
  end
end
