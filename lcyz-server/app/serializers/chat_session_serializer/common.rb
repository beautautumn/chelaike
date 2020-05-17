module ChatSessionSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :nickname, :avatar

    def id
      object.user_id
    end
  end
end
