module ChatSerializer
  module Company
    class WithUsers < ActiveModel::Serializer
      attributes :id, :name, :users_count

      has_many :enabled_users, key: :users, serializer: ChatSerializer::User::Basic

      def users_count
        object.enabled_users.size
      end
    end
  end
end
