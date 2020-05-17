module ChatSessionSerializer
  class Alliance < ActiveModel::Serializer
    attributes :id, :name, :users_count, :users

    def id
      object[0].id
    end

    def name
      object[0].name
    end

    def users_count
      object[1].size
    end

    def users
      object[1].map { |u| { id: u.user_id, nickname: u.nickname, avatar: u.avatar } }
    end
  end
end
