module AntQueen
  module Request
    def ant_post(path:, params:)
      url = "#{ENV["ANT_QUEEN_URL"]}#{path}"
      req = RestClient::Request.execute(method: :post, url: url, payload: params, timeout: 5)
      result = JSON.parse(req)
      result
    rescue => _e
      nil
    end
  end
end
