module Operation
  class Session
    def self.info(user)
      ActiveModel::Serializer::Adapter::Json.new(
        SessionSerializer::Common.new(user, root: "data")
      ).to_json
    end

    def self.find_by_token(user_token)
      token = user_token.match(/AutobotsAuth (.*)/).captures.first

      user_id = JWT.decode(token, Rails.application.secrets[:secret_token])
                   .first.fetch("user_id")

      User.find(user_id)
    end
  end
end
