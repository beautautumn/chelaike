# 联盟公司用户controller
module V1
  module AllianceDashboard
    class UsersController < V1::AllianceDashboard::ApplicationController
      before_action except: [:update, :me] do
        authorize AllianceCompany::User
      end

      def index
        basic_params_validations

        users = paginate policy_scope(current_user.current_company_users)
                .includes(:alliance_company, :authority_roles, :manager)
                .ransack(params[:query]).result
                .order(:first_letter, :name)

        render json: users,
               each_serializer: AllianceDashboardSerializer::UserSerializer::Common,
               root: "data"
      end

      def show
        render json: AllianceCompany::User.find(params[:id]),
               serializer: AllianceDashboardSerializer::UserSerializer::Common,
               root: "data"
      end

      def create
        service = AllianceCompanyService::User::CRUD.new(current_user, user_params)
        new_user = service.create
        render json: new_user,
               serializer: AllianceDashboardSerializer::UserSerializer::Common,
               root: "data"
      rescue AllianceCompanyService::User::CRUD::CreateError => e
        validation_error(e.message)
      end

      def update
        user = find_user(params[:id])
        authorize user

        service = AllianceCompanyService::User::CRUD.new(current_user, user_params)
        service.update(user)

        render json: user,
               serializer: AllianceDashboardSerializer::UserSerializer::Common,
               root: "data"
      rescue AllianceCompanyService::User::CRUD::UpdateError => e
        validation_error(e.message)
      end

      def destroy
        user = find_user(params[:id])
        if user.id == current_user.alliance_company.owner_id
          return forbidden_error("公司拥有者无法被删除")
        end

        render json: user.destroy,
               serializer: AllianceDashboardSerializer::UserSerializer::Common,
               root: "data"
      end

      # 禁用，启用
      def state
        param! :user, Hash do |u|
          u.param! :state, String, blank: false, required: true,
                                   in: AllianceCompany::User.state.values, transform: :downcase
        end

        user = find_user(params[:id])
        user.update(state: params[:user][:state])

        if user.errors.empty?
          render json: user,
                 serializer: AllianceDashboardSerializer::UserSerializer::Common,
                 root: "data"
        else
          validation_error(full_errors(user))
        end
      end

      def me
        render json: current_user,
               serializer: AllianceDashboardSerializer::UserSerializer::CommonWithToken,
               root: "data"
      end

      private

      def user_params
        settings = %i(
          mac_address_lock device_number_lock cross_shop_read cross_shop_edit
          cross_shop_read_statistic
        )

        params.require(:user).permit(
          :username, :password, :name, :email, :phone, :manager_id, :state, :avatar,
          :is_alliance_contact, :note, { settings: settings },
          { authority_role_ids: [] }, :authority_type, authorities: []
        ).tap do |white_listed|
          white_listed[:authority_role_ids] ||= []
          white_listed[:authorities] ||= []
        end
      end

      def find_user(user_id)
        AllianceCompany::User.find(user_id)
      end
    end
  end
end
