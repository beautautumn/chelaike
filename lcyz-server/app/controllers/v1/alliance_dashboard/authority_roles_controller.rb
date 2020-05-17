# 联盟公司的角色管理
module V1
  module AllianceDashboard
    class AuthorityRolesController < V1::AllianceDashboard::ApplicationController
      before_action do
        authorize AuthorityRole
      end

      def index
        render json: authority_role_scope.all,
               each_serializer: AllianceDashboardSerializer::AuthorityRoleSerializer::Common,
               root: "data"
      end

      # 创建角色
      def create
        param! :authority_role, Hash do |a|
          a.param! :name, String, required: true, blank: false
        end

        current_company = current_user.alliance_company

        authority_role_service = AllianceCompanyService::AuthorityRole::Create.new(
          current_company.id, current_user.id
        )

        begin
          role = authority_role_service.create(name: authority_role_params[:name],
                                               note: authority_role_params[:note],
                                               authorities: authority_role_params[:authorities])

          render json: role,
                 serializer: AllianceDashboardSerializer::AuthorityRoleSerializer::Create,
                 root: "data"
        rescue ActiveRecord::RecordInvalid => e
          validation_error(e.message)
        end
      end

      def destroy
        render json: authority_role_scope.find(params[:id]).destroy,
               serializer: AllianceDashboardSerializer::AuthorityRoleSerializer::Common,
               root: "data"
      end

      private

      def authority_role_params
        if params[:authority_role] && params[:authority_role].key?(:authorities)
          params[:authority_role][:authorities] ||= []
        end

        params.require(:authority_role).permit(:name, :note, authorities: [])
      end

      def authority_role_scope
        current_user.alliance_company.authority_roles
      end
    end
  end
end
