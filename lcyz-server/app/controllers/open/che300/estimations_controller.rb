module Open
  module Che300
    class EstimationsController < BaseController
      def index
        get_proxy("http://api.che300.com/service/getUsedCarPrice") do
          args = params.fetch(:params, {})
                       .dup
                       .extract!(:modelId, :regDate, :mile, :zone)
                       .to_json

          "che300:estimations:" + Digest::MD5.hexdigest(args)
        end
      end
    end
  end
end
