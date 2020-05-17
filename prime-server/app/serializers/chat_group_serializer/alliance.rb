module ChatGroupSerializer
  class Alliance < ActiveModel::Serializer
    attributes :id, :name, :current_user, :alliance, :logo, :group_type

    has_many :alliance_users,
             key: :companies, serializer: ChatSessionSerializer::Alliance, if: :sale?

    has_many :alliance_users,
             key: :users, serializer: ChatSessionSerializer::Common, if: :acquisition?
    attribute :users_count, if: :acquisition?

    def current_user
      instance_options[:my_chat_info]
    end

    def sale?
      object.group_type == "sale"
    end

    def acquisition?
      object.group_type == "acquisition"
    end

    def users_count
      alliance_users.count
    end

    def alliance_users
      case object.group_type
      when "sale"
        object.chat_sessions.group_by { |u| u.user.company }
              .to_a.sort_by { |a| a[0].id == instance_options[:current_company_id] ? 1 : 2 }
      when "acquisition"
        object.chat_sessions
      end
    end

    def alliance
      alliance = object.organize
      acr = alliance.alliance_company_relationships
                    .find_by(company_id: instance_options[:current_company_id])
      { name: alliance.name, nickname: acr.try(:nickname) }
    end
  end
end
