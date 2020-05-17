module Open
  module V2
    class BrandsController < Open::ApplicationController
      include Brands

      def index
        return super unless params.key?(:relative)

        # brands = current_company_cars
        #          .where(sellable: true)
        #          .state_in_stock_scope
        #          .where("brand_name is not null")
        #          .where.not(brand_name: "")
        #          .select(:brand_name, "count(cars.id) AS cars_size")
        #          .group(:brand_name).order("cars_size desc")
        #          .map do |car|
        #            pinyin = Util::Brand.to_pinyin(car.brand_name)
        #            next if pinyin.blank?

        #            {
        #              first_letter: pinyin.upcase,
        #              name: car.brand_name,
        #              logo: top_brand_links.fetch(car.brand_name, "")
        #            }
        #          end
        brands = BrandsService.official_cars_brands(current_company_cars)

        render json: { data: brands.compact }, scope: nil
      end

      def series
        return super unless params.key?(:relative)

        # series = current_company_cars
        #          .where(sellable: true)
        #          .state_in_stock_scope
        #          .where("brand_name is not null")
        #          .where.not(brand_name: "")
        #          .where("series_name is not null")
        #          .where.not(series_name: "")
        #          .select(:brand_name, :series_name, "count(cars.id) AS cars_size")
        #          .group(:brand_name, :series_name).order("cars_size desc")
        #          .map do |car|
        #            pinyin = Util::Brand.to_pinyin(car.series_name)
        #            next if pinyin.blank?

        #            {
        #              first_letter: pinyin.upcase,
        #              name: car.series_name,
        #              brand_name: car.brand_name
        #            }
        #          end

        series = BrandsService.official_cars_series(current_company_cars)

        render json: { data: series.compact }, scope: nil
      end

      def scope
        current_company
      end

      def top_brand_links
        @_top_brand_links ||= I18n.t("top_brands").with_indifferent_access
      end
    end
  end
end
