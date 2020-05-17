module Che3bao
  class BrandsController < Che3bao::ApplicationController
    def brands
      @brands = Megatron.brands["data"]
      brands_decorator

      render json: { data: @brands }, scope: nil
    end

    def series
      @series = Megatron.series(params[:parentCode])["data"]
      series_decorator

      render json: { data: @series }, scope: nil
    end

    def styles
      @styles = Megatron.styles(params[:parentCode])["data"]
      styles_decorator

      render json: { data: @styles }, scope: nil
    end

    private

    def styles_decorator
      @styles = @styles.each_with_object([]) do |year, styles|
        year["models"].each do |style|
          styles << { modelCode: style["name"], modelName: style["name"] }
        end

        styles
      end
    end

    def series_decorator
      @series = @series.each_with_object([]) do |manufacturer, list|
        manufacturer["series"].each do |series|
          list << { seriesCode: series["name"], seriesName: series["name"] }
        end

        list
      end
    end

    def brands_decorator
      @brands.map! do |brand|
        {
          brandCode: brand["name"],
          brandName: brand["name"],
          brandPinYin: Pinyin.t(brand["name"]),
          brandFirstLetter: brand["first_letter"]
        }
      end
    end
  end
end
