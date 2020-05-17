module V1
  class AuthorityRolesController < ApplicationController
    before_action do
      authorize AuthorityRole
    end

    def index
      render json: authority_role_scope.all,
             each_serializer: AuthorityRoleSerializer::Common,
             root: "data"
    end

    def show
      render json: authority_role_scope.find(params[:id]),
             serializer: AuthorityRoleSerializer::Common,
             root: "data"
    end

    def update
      authority_role = authority_role_scope.find(params[:id])
      authority_role.update(authority_role_params)
      authority_role.users.each(&:save)

      if authority_role.errors.empty?
        render json: authority_role,
               serializer: AuthorityRoleSerializer::Common,
               root: "data"
      else
        validation_error(full_errors(authority_role))
      end
    end

    def create
      param! :authority_role, Hash do |a|
        a.param! :name, String, required: true, blank: false
      end

      authority_role = authority_role_scope.create(authority_role_params)

      if authority_role.errors.empty?
        render json: authority_role,
               serializer: AuthorityRoleSerializer::Create,
               root: "data"
      else
        validation_error(full_errors(authority_role))
      end
    end

    def destroy
      render json: authority_role_scope.find(params[:id]).destroy,
             serializer: AuthorityRoleSerializer::Common,
             root: "data"
    end

    private

    def authority_role_params
      # 防止空数组变成nil
      if params[:authority_role] && params[:authority_role].key?(:authorities)
        params[:authority_role][:authorities] ||= []
      end

      params.require(:authority_role).permit(:name, :note, authorities: [])
    end

    def authority_role_scope
      AuthorityRole.where(company_id: current_user.company_id)
    end
  end
end
