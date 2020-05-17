module V1
  class StylesController < ApplicationController
    before_action :find_series
    def index
      style_name = style_params[:name]
      if style_name
        find_style_by_name(style_name)
        render json: { data: @style }
      else
        find_styles
        render json: { data: @styles }
      end
    end

    private

    def guide_price
      return unless @data.try(:[], "基本参数").try(:[], "厂商指导价(元)")

      (@data["基本参数"]["厂商指导价(元)"]
        .delete("万").to_f * 10_000).to_i
    end

    def search_price(price, data)
      price.each do |region, value|
        province, city = region.split(" ")

        next unless data[:city].include?(city) &&
                    data[:province].include?(province)

        data[:minimum_price] = value[:minimum_price]
        data[:city] = city
        data[:province] = province

        break
      end

      data
    end

    def price_data
      data = {
        province: region_params[:province] || "",
        city: region_params[:city] || "",
        guide_price: guide_price,
        minimum_price: nil
      }

      begin
        price = StylePrice.find_by(code: @style_id)
      rescue Mongoid::Errors::DocumentNotFound
        return data
      end

      return data unless price

      search_price(price.data, data)
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def find_style_by_name(style_name)
      find_styles

      @style = {}
      @style[:car_configuration] = []

      style_found = false
      @styles.each do |style_cag|
        style_cag[:models].each do |model|
          style_found = style_name == model[:name]

          next unless style_found

          @style_id = model[:id]
          begin
            configuration = StyleConfiguration.find_by(code: @style_id).data
          rescue Mongoid::Errors::DocumentNotFound
            configuration = []
          end

          @data = configuration

          break
        end

        break if style_found
      end
      @style[:car_configuration] = []
      @data = default_field if @data.nil? || @data.size <= 0

      @data.each do |param, fields|
        field_group = { name: param, fields: [] }

        fields.each do |field, value|
          next unless visible_fields.include?(field)

          value = get_value(value)
          # value.gsub!(/欧/, "国") if field == "环保标准"

          the_field = {
            name: field,
            value: value,
            type: "text"
          }

          the_field[:type] = "select" if selects_field.include?(field)
          if %w(select text).include?(value)
            the_field[:type] = value
            the_field[:value] = ""
          end

          field_group[:fields] << the_field
        end

        @style[:car_configuration] << field_group unless field_group[:fields].empty?
      end

      @style[:price] = {
        province: "",
        city: "",
        guide_price: nil,
        minimum_price: nil
      }

      if @style_id
        @style[:price] = price_data
        @style[:code] = @style_id
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    def get_value(value)
      value = "标配" if value.include?("标配")
      value = "选配" if value.include?("选配")

      value
    end

    def find_styles
      if @series_id
        @styles = Style.where(series_code: @series_id).pluck(:styles).first || []
        @styles.sort! do |a, b| b["year"] <=> a["year"] end
        @styles.each do |style|
          style[:models].each do |model|
            begin
              model[:guide_price] = StyleConfiguration.find_by(code: model[:id]).data["基本参数"]["厂商指导价(元)"]
            rescue
              model[:guide_price] = nil
            end
          end
        end
      else
        @styles = []
      end
    end

    def find_series
      series_name = series_params[:name]
      begin
        @series_id = Series.find_by(name: series_name)[:code]
      rescue Mongoid::Errors::DocumentNotFound
        @series_id = nil
      end
    end

    def visible_fields
      @visible_fields ||= YAML.load_file("#{Rails.root}/lib/car_configuration/fields.yml")
                          .with_indifferent_access[:visible].split(" ")
    end

    def selects_field
      @selects_field ||= YAML.load_file("#{Rails.root}/lib/car_configuration/fields.yml")
                         .with_indifferent_access[:optional].split(" ")
    end

    def default_field
      @default_field ||= YAML.load_file("#{Rails.root}/lib/car_configuration/fields.yml")
                         .with_indifferent_access[:default]
    end

    def series_params
      params.require(:series).permit(:name)
    end

    def style_params
      return params.require(:style).permit(:name) if params[:style]

      {}
    end

    def region_params
      params.require(:region).permit(:city, :province)
    end
  end
end
