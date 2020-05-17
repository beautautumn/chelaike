module Open
  module Che300
    class BrandsController < BaseController
      def index
        get_proxy("http://api.che300.com/service/getCarBrandList") do
          "che300:brands"
        end
      end

      def series
        get_proxy("http://api.che300.com/service/getCarSeriesList") do
          brand_id = params.fetch(:params, {})[:brandId]
          "che300:series:#{brand_id}"
        end
      end

      def styles
        get_proxy("http://api.che300.com/service/getCarModelList") do
          series_id = params.fetch(:params, {})[:seriesId]
          "che300:styles:#{series_id}"
        end
      end
    end
  end
end
