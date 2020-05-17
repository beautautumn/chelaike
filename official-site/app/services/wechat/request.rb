# frozen_string_literal: true
module Wechat
  module Request
    def wechat_post(url, params = {}, _options = {})
      JSON.parse RestClient.post(url, params.to_json, content_type: :json).body
    end

    def wechat_get(url, _options = {})
      JSON.parse RestClient.get(url).body
    end
  end
end
