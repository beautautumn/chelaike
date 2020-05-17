module AntQueen
  class Token
    extend AntQueen::Request

    def self.get
      path = "/OpenPublicApi/getToken".freeze
      result = ant_post(
        path: path,
        params: { partner_id: ENV["ANT_QUEEN_ID"], secret_key: ENV["ANT_QUEEN_KEY"] }
      )
      raise AntQueen::Error::Token if result.blank? || result["code"] != "200"
      result["token"]
    end
  end
end
