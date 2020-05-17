module V1
  class UsersController < ApplicationController
    before_action only: [:index, :selector] do
      authorize User
    end

    before_action :create_validation, only: :create
    before_action :skip_authorization, only: %i(feedback client_info subordinate_users me query_shop)

    def index
      basic_params_validations

      if params.key?(:intention)
        users = current_company_users.ransack(params[:query]).result
                                     .order(:first_letter, :name)

        return render json: users,
                      each_serializer: UserSerializer::Intention,
                      root: "data"
      else
        users = paginate policy_scope(current_company_users)
                .includes(:shop, :company, :authority_roles, :manager)
                .ransack(params[:query]).result
                .order_by_state
                .order(:first_letter, :name)

        return render json: users, each_serializer: UserSerializer::Common, root: "data"
      end
    end

    def selector
      users = policy_scope(current_company_users)
              .ransack(params[:query]).result.order(:first_letter, :name)

      render json: users, each_serializer: UserSerializer::Mini, root: "data"
    end

    def create
      user = User.new(user_params.merge(company_id: current_user.company_id))
      authorize user

      user.save
      if user.errors.empty?
        render json: user, serializer: UserSerializer::Common, root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def update
      user = find_user(params[:id])

      user.update(user_params)

      if user.errors.empty?
        render json: user, serializer: UserSerializer::Common, root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def mobile_app_car_detail_menu
      user = find_user(params[:id])

      user.update_columns(
        mobile_app_car_detail_menu: user_params[:mobile_app_car_detail_menu]
      )

      render json: user, serializer: UserSerializer::Common, root: "data"
    end

    def state
      param! :user, Hash do |u|
        u.param! :state, String, blank: false, required: true,
                                 in: User.state.values, transform: :downcase
      end

      user = find_user(params[:id])
      user.update(state: params[:user][:state])

      if user.errors.empty?
        render json: user, serializer: UserSerializer::Common, root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def feedback
      current_user.update(feedback_params)

      if current_user.errors.empty?
        render json: current_user, serializer: UserSerializer::Common, root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def destroy
      user = find_user(params[:id])
      if user.id == current_user.company.owner_id
        return forbidden_error("公司拥有者无法被删除")
      end

      render json: user.destroy,
             serializer: UserSerializer::Common,
             root: "data"
    end

    def show
      render json: find_user(params[:id]),
             serializer: UserSerializer::Common, root: "data"
    end

    def me
      render json: current_user,
             serializer: UserSerializer::CommonWithToken, root: "data",
             meta: {
               acquisition_shops: policy_scope(current_user.company.shops.order(id: :desc))
             }
    end

    def client_info
      current_user.update_columns(
        client_info: params[:user].fetch(:client_info, {})
      ) if params[:user].present?

      render json: { message: :ok }, scope: nil
    end

    def subordinate_users
      user = current_company_users.find(params[:user_id])

      users = user.subordinate_users
                  .where.not(id: user.id)
                  .order("first_letter asc")

      render json: users,
             each_serializer: UserSerializer::Intention,
             root: "data"
    end

    def query_shop
      shop_id = params[:shop_id]

      users = if shop_id
                current_company_users.where(shop_id: shop_id)
              else
                []
              end

      render json: users,
             each_serializer: UserSerializer::Common,
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
        :is_alliance_contact, :note, :mac_address, :shop_id, :qrcode_url,
        :self_description, { settings: settings },
        { authority_role_ids: [] }, :authority_type, { authorities: [] },
        device_numbers: [], mobile_app_car_detail_menu: []
      ).tap do |hash|
        if hash[:authority_type] == "custom"
          hash[:authority_role_ids] = []
        else
          hash.delete(:authorities)
        end

        unless current_user.can?("员工管理")
          hash.except!(*[:mac_address].concat(settings))
          hash.fetch(:settings, {}).except!(*settings)
          hash[:device_numbers] = []
        end
      end
    end

    def feedback_params
      params.require(:user).permit(feedbacks_attributes: [:id, :note, :_destroy])
    end

    def create_validation
      param! :user, Hash do |u|
        u.param! :password,           String, blank: false, required: true
        u.param! :name,               String, blank: false, required: true
        u.param! :phone,              String, blank: false, required: true
        u.param! :authority_role_ids, Array
        u.param! :authorities,        Array
      end
    end

    def current_company_users
      User.where(company_id: current_user.company_id)
    end

    def find_user(id)
      user = current_company_users.find(id)
      authorize user

      user
    end
  end
end
