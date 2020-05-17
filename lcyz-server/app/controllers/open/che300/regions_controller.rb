module Open
  module Che300
    class RegionsController < BaseController
      def index
        get_proxy("http://api.che300.com/service/getAllCity") do
          "che300:regions"
        end
      end
    end
  end
end
