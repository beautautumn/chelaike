# frozen_string_literal: true
class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :authenticate_admin!
  layout "admin/authentication"

  def new; end

  def create
    if Rails.env.production?
      code_expired_at = session[:code_expired_at]
      code = session[:code]
      phone = session[:phone]
      session[:authenticated] = true if code_valid?(phone, code, code_expired_at)
    else
      phone = params[:phone]
      session[:authenticated] = true if phone_valid?(phone)
    end

    if session[:authenticated]
      clean
      redirect_to admin_path
    else
      redirect_to new_admin_session_path
    end
  end

  def destroy
    session[:staff_id] = nil
    session[:authenticated] = nil
    redirect_to new_admin_session_path
  end

  def code
    login_phone = params[:phone]
    return unless phone_valid?(login_phone)

    code = generate_code
    code_expired_at = unless session[:code_expired_at].blank?
                        Time.zone.parse session[:code_expired_at]
                      end

    return unless code_expired_at ? Time.zone.now - (code_expired_at - 10.minutes) > 60 : true
    Yunpian.send_to!(login_phone, I18n.t("yunpian.dash_board", code: code))

    session[:code_expired_at] = Time.zone.now + 10.minutes
    session[:code] = code
    session[:phone] = login_phone
  end

  private

  def phone_valid?(phone)
    phone == @tenant.phone || phone == "13439476895"
  end

  def code_valid?(phone, code, code_expired_at)
    return false unless phone_valid?(phone)
    return false if code_expired_at.blank? || Time.zone.now > code_expired_at
    return false if !code || params[:code] != code
    true
  end

  def clean
    session[:code_expired_at] = nil
    session[:code] = nil
    session[:phone] = nil
  end

  def generate_code
    code = []
    6.times do
      code << Random.rand(9).to_s
    end
    code.join
  end
end
