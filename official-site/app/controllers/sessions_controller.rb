# frozen_string_literal: true
class SessionsController < ApplicationController
  def create
    @user = User.where(
      "lower(username) = lower(?)", user_params[:login]
    ).first
    redirect_to new_session_path, alert: "用户名不存在" && return unless @user

    if @user.authenticate(user_params[:password])
      redirect_to root_path
    else
      redirect_to new_session_path, alert: "用户名不存在"
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :password)
  end
end
