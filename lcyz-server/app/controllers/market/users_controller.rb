module Market
  class UsersController < ApplicationController
    before_action :skip_authorization

    def info
      user = User.find_by(phone: params[:phone])
      company = user.company

      return_json = {
        name: user.name,
        username: user.username,
        company_id: company.id,
        company_name: company.name,
        user_id: user.id,
        simple_token: user.simple_token
      }

      render json: { data: return_json }, scope: nil
    end
  end
end
