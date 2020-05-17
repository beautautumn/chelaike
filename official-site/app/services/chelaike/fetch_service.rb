# frozen_string_literal: true
module Chelaike
  class FetchService
    ChelaikeRequestError = Class.new(StandardError)
    class << self
      def get(url, company_id = nil, params = nil, struct_response = true)
        request(:get, url, company_id, params, struct_response)
      end

      def post(url, company_id = nil, params = nil, struct_response = true)
        request(:post, url, company_id, params, struct_response)
      end

      def patch(url, company_id = nil, params = nil, struct_response = true)
        request(:patch, url, company_id, params, struct_response)
      end

      def request(method, url, company_id = nil, params = nil, struct_response = true)
        return nil unless method == :get || method == :post || method == :patch
        request_params = {}
        request_params[:id] = company_id.presence
        request_params[:expired_at] = Time.zone.now + 1.hour

        token = {
          "AutobotsOpenToken": JWT.encode(request_params,
                                          ENV.fetch("OPEN_APP_SECRET"),
                                          "HS256")
        }

        response = RestClient::Request.execute(
          method: method,
          url: host + url,
          headers: token,
          payload: params,
          timeout: 5
        )
        raise ChelaikeRequestError unless response.code == 200

        if struct_response
          MultiJson.load(response.body, symbolize_keys: true, object_class: OpenStruct)
        else
          MultiJson.load(response.body, symbolize_keys: true)
        end
      end

      def host
        ENV.fetch("CHELAIKE_URL")
      end

      def secret
        ENV.fetch("OPEN_APP_SECRET")
      end
    end
  end
end
# 避免 json 出现 "table"
require "ostruct"
class OpenStruct
  def as_json(options = nil)
    @table.as_json(options)
  end
end
