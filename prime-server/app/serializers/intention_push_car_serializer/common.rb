module IntentionPushCarSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :created_at, :intention_id, :intention

    belongs_to :intention, serializer: IntentionSerializer::Mini
  end
end
