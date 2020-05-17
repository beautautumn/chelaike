module UserSerializer
  class ChatGroup < ActiveModel::Serializer
    attributes :id, :name, :avatar
  end
end
