module ConversationSerializer
  class Common < ActiveModel::Serializer
    attributes :target_id, :conversation_type, :is_blocked, :is_top
  end
end
