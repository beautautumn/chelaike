class User < ActiveRecord::Base
  class AuthorityService
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def init_default_roles!
      authority_roles = YAML.load_file("#{Rails.root}/config/authority_roles.yml")
                            .with_indifferent_access

      authority_roles.each do |name, role|
        role_id = create_role(name, role[:note], role[:authorities].split(" ")).id
        assign(role_id) if name == "老板"
      end
    end

    def append(authority_role_id)
      begin
        User.transaction do
          @user.authority_role_ids |= ([] << authority_role_id).flatten
          @user.save!
        end
      rescue ActiveRecord::RecordInvalid
        @user
      end

      self
    end

    def assign(authority_role_id)
      begin
        User.transaction do
          @user.authority_role_ids = ([] << authority_role_id).flatten
          @user.save!
        end
      rescue ActiveRecord::RecordInvalid
        @user
      end

      self
    end

    def remove(authority_role_id)
      begin
        User.transaction do
          return false unless @user.authority_roles.exists?(authority_role_id)

          @user.authority_role_relationships
               .find_by!(authority_role_id: authority_role_id)
               .delete
          @user.save!
        end
      rescue ActiveRecord::RecordInvalid
        @user
      end

      self
    end

    private

    def create_role(name, note, authorities)
      @user.company.authority_roles.create(
        name: name, note: note, authorities: authorities
      )
    end
  end
end
