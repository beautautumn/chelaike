module Dashboard
  class SessionsController < ApplicationController
    skip_before_action :authenticate_staff!
    skip_after_action :verify_authorized

    layout "dashboard/authentication"

    def create
      if Rails.env.dashboard? || Rails.env.production?

        code_expired_at = session[:code_expired_at]
        code = session[:code]
        phone = session[:phone]
        staff = Staff.find_by(phone: phone, state: "enabled")

        if staff && code_valid?(phone, code, code_expired_at)
          session[:staff_id] = staff.try(:id)
        end
      else
        phone = params[:phone]
        staff = Staff.find_by(phone: phone, state: "enabled")
        session[:staff_id] = staff.try(:id)
      end

      if session[:staff_id]
        clean

        if staff.consultant?
          redirect_to root_path
        elsif staff.developer?
          redirect_to apps_path
        else
          redirect_to root_path
        end
      else
        redirect_to new_session_path
      end
    end

    def destroy
      session[:staff_id] = nil
      redirect_to new_session_path
    end

    def new
    end

    def code
      login_phone = params[:phone]
      staff = Staff.find_by(phone: login_phone, state: "enabled")

      if staff
        code = generate_code
        code_expired_at = session[:code_expired_at]

        return unless SMS.can?(code_expired_at)
        Yunpian.send_to!(login_phone, I18n.t("yunpian.dash_board", code: code))

        session[:code_expired_at] = Time.zone.now + 2.minutes
        session[:code] = code
        session[:phone] = login_phone
      end
    end

    private

    def code_valid?(phone, code, code_expired_at)
      return false unless phone
      return false if !code_expired_at || Time.zone.now > code_expired_at
      return false if !code || params[:code] != code
      true
    end

    def clean
      session[:code_expired_at] = nil
      session[:code] = nil
      session[:phone] = nil
    end

    def generate_code
      code = ""
      6.times do
        code << Random.rand(9).to_s
      end
      code
    end
  end
end
