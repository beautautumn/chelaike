class EasyLoan::AuthoritiesController < EasyLoan::ApplicationController
  def index
    param! :user_id, Integer

    if params[:user_id]
      user = EasyLoan::User.find(params[:user_id])
      render json: { data: user.authorities }, scope: nil
    else
      render json: { data: EasyLoan::User.authorities }, scope: nil
    end
  end
end
