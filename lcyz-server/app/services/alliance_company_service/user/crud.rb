module AllianceCompanyService
  module User
    class CRUD
      class CreateError < StandardError; end
      class UpdateError < StandardError; end

      attr_accessor :operator, :user_params

      def initialize(operator, user_params)
        @operator = operator
        @user_params = sanitized_car_params(user_params)
      end

      def create
        raise CreateError, "没有员工管理权限" unless @operator.can?("员工管理")
        user = AllianceCompany::User.new(
          @user_params.merge(
            company_id: @operator.company_id,
            manager_id: @operator.id
          )
        )

        user.save!
        user
      end

      def update(user)
        raise UpdateError, "没有员工管理权限" unless @operator.can?("员工管理") || @operator == user
        user.update!(@user_params)
        user
      end

      private

      def sanitized_car_params(user_params)
        user_params.tap do |hash|
          if hash[:authority_type] == "role"
            hash[:authorities] = role_user_params(hash)
          else
            hash[:authority_role_ids] = []
          end
        end
      end

      def role_user_params(user_params_hash)
        role_ids = user_params_hash[:authority_role_ids]
        AllianceCompany::AuthorityRole.where(id: role_ids)
                                      .map(&:authorities)
                                      .flatten.uniq
      end
    end
  end
end
