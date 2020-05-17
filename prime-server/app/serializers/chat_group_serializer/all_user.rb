module ChatGroupSerializer
  class AllUser < ActiveModel::Serializer
    attributes :id, :name, :type, :logo, :group_type

    has_many :alliance_users,
             key: :companies, serializer: ChatSessionSerializer::Alliance

    def alliance_users
      object.chat_sessions.group_by { |u| u.user.company }.to_a
    end

    def type
      object.organize_type.downcase
    end
  end
end
