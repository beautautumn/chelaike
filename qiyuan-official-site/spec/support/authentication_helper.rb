# frozen_string_literal: true
module AuthenticationHelper
  def login_tenant
    session[:authenticated] = true
  end
end
