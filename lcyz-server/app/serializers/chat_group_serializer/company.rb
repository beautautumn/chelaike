module ChatGroupSerializer
  class Company < ActiveModel::Serializer
    attributes :id, :name, :current_user, :logo

    has_many :chat_sessions,
             key: :users, serializer: ChatSessionSerializer::Common

    def current_user
      instance_options[:my_chat_info]
    end
  end
end
