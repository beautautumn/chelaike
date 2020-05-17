# frozen_string_literal: true
class Admin::ApplicationController < ApplicationController
  before_action :authenticate_admin!

  layout "admin/application"

  def authenticate_admin!
    return if Rails.env.in?(%w(staging development))
    redirect_to new_admin_session_path unless session[:authenticated]
  end
end
