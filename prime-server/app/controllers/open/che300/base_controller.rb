module Open
  module Che300
    class BaseController < Open::ApplicationController
      def get_proxy(host)
        response = if block_given?
                     Rails.cache.fetch(yield) { String.new(send_request(host)) }
                   else
                     send_request(host)
                   end

        render json: MultiJson.load(response), scope: nil
      rescue StandardError => e
        render json: { message: e.message }, scope: nil
      end

      private

      def send_request(host)
        query = params.fetch(:params, {})
                      .merge(token: ENV.fetch("CHE_300_TOKEN"))
                      .to_query

        Util::Request.get("#{host}?#{query}", open_timeout: 5)
      end
    end
  end
end
