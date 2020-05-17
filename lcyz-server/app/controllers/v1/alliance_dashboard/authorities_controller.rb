module V1
  module AllianceDashboard
    class AuthoritiesController < V1::AllianceDashboard::ApplicationController
      def index
        if params[:user_id]
          user = AllianceCompany::User.find(params[:user_id])
          authorize(user, :manage?)

          render json: user,
                 serializer: AllianceDashboardSerializer::UserSerializer::AuthorityRoles,
                 root: "data"
        else
          skip_authorization
          render json: { data: AllianceCompany::User.authorities_hash }, scope: nil
        end
      end
    end
  end
end
