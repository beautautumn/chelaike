# frozen_string_literal: true
module Chelaike
  class Util
    RequestError = Class.new(StandardError)
    def self.shorten_url(url)
      params = {
        q: url
      }

      response = RestClient::Request.execute(
        method: :post,
        url: "http://server.chelaike.com/api/util/shortener",
        payload: params,
        timeout: 5
      )
      raise RequestError unless response.code == 200
      response.body
    end
  end
end
