module Open
  module Che300
    class CarsController < BaseController
      def index
        get_proxy("http://api.che300.com/service/getCarList")
      end

      def detail
        get_proxy("http://api.che300.com/service/getCarDetail")
      end
    end
  end
end
