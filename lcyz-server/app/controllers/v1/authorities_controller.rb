module V1
  class AuthoritiesController < ApplicationController
    before_action :init_authority_service, except: :index

    def index
      if params[:user_id]
        user = User.find(params[:user_id])
        authorize(user, :manage?)

        render json: user,
               serializer: UserSerializer::AuthorityRoles,
               root: "data"
      else
        skip_authorization
        render json: { data: User.authorities_hash }, scope: nil
      end
    end

    def create
      @authority_service.append(user_params[:authority_role_id])
      user = @authority_service.user
      authorize user

      if user.errors.empty?
        render json: user,
               serializer: UserSerializer::AuthorityRoles,
               root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def destroy
      @authority_service.remove(user_params[:authority_role_id])
      user = @authority_service.user
      authorize user

      if user.errors.empty?
        render json: user,
               serializer: UserSerializer::AuthorityRoles,
               root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def custom
      user = User.where(company_id: current_user.company_id)
                 .find(params[:user_id])
      authorize user

      user.update(user_authorities_params)

      if user.errors.empty?
        render json: user,
               serializer: UserSerializer::AuthorityRoles,
               root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def authority_roles
      user = User.find(params[:user_id])
      authorize user

      render json: user,
             serializer: UserSerializer::AuthorityRoles,
             root: "data"
    end

    private

    def init_authority_service
      user = User.find(params[:user_id])
      @authority_service = User::AuthorityService.new(user)
    end

    def user_params
      params.require(:user).permit(:authority_role_id)
    end

    def user_authorities_params
      params.require(:user)
            .permit(authorities: [])
            .merge!(authority_type: "custom")
    end
  end
end
