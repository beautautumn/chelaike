module Open
  module V2
    class CitiesController < Open::ApplicationController
      # 得到某家公司所有分店的城市
      def index
        names = current_company.cities_name

        render json: { data: names }
      end
    end
  end
end
