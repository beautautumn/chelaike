# frozen_string_literal: true
class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :authenticate_admin!
  layout "admin/authentication"

  def new; end

  def create
    msg = Chelaike::SessionService.verify(session[:phone], params[:code], @tenant.company_id)
    session[:authenticated] = msg == "ok"
    if session[:authenticated]
      redirect_to admin_path
    else
      redirect_to new_admin_session_path
    end
  end

  def destroy
    session[:staff_id] = nil
    session[:phone] = nil
    session[:authenticated] = nil
    redirect_to new_admin_session_path
  end

  def code
    login_phone = params[:phone]
    session[:phone] = login_phone
    msg = Chelaike::SessionService.verification_code(login_phone, @tenant.company_id)
    render json: { msg: msg }, scope: nil
  end
end
