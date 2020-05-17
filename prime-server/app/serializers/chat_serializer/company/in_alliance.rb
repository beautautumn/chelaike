module ChatSerializer
  module Company
    class InAlliance < ActiveModel::Serializer
      def initialize(object, options = {})
        super
        alliance_id = instance_options[:alliance_id]
        instance_options[:company_nickname] = object.alliance_company_relationships
                                                    .where(alliance_id: alliance_id)
                                                    .first.nickname
      end

      attributes :id, :name, :users_count, :users

      has_many :enabled_users, key: :users, serializer: ChatSerializer::User::Basic

      def users_count
        object.chat_users.size
      end
    end
  end
end
