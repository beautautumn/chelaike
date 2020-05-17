module AllianceCompanyService
  module AuthorityRole
    CreateError = Class.new(StandardError)

    class Create
      attr_accessor :company, :user

      def initialize(company_id, user_id)
        @company = AllianceCompany::Company.find(company_id)
        @user = AllianceCompany::User.find(user_id)
      end

      def create(name: nil, note: "", authorities: [])
        raise CreateError, "没有操作权限" unless @user.authorities.include?("角色管理")
        @company.authority_roles.create!(name: name, note: note, authorities: authorities)
      end

      def grant_manager_authorities
        superman_role = AllianceCompany::AuthorityRole.find_or_create_super_manager(@company)
        superman_role.alliance_authority_role_relationships.create(user_id: @user.id)
        @user.authorities = superman_role.authorities
        @user.save!
      end
    end
  end
end
