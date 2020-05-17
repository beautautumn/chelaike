module ChatGroupSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :name, :type, :logo, :group_type
    attribute :current_user, if: :current_user_existed?
    attribute :users_count, if: :users_count?

    def users_count?
      instance_options[:users_count]
    end

    def users_count
      object.users.size
    end

    def type
      object.organize_type.downcase
    end

    def current_user_existed?
      instance_options[:current_user_existed]
    end

    def current_user
      result = scope.chat_sessions.pluck(:target_id).include?(object.id)
      { persist: result }
    end
  end
end
