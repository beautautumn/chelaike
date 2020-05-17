module Open
  module Che300
    class IdentifyCarsController < BaseController
      def index
        get_proxy("http://api.che300.com/service/identifyModel") do
          args = params.fetch(:params, {})
                       .dup
                       .extract!(:brand, :series, :model, :modelYear, :modelPrice)
                       .to_json

          "che300:identify_cars:" + Digest::MD5.hexdigest(args)
        end
      end
    end
  end
end
