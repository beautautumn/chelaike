module Brands
  extend ActiveSupport::Concern

  def index
    render json: Megatron.brands, scope: nil
  end

  def series
    render json: Megatron.series(brand_params[:name]), scope: nil
  end

  def styles
    render json: Megatron.styles(series_params[:name]), scope: nil
  end

  def style
    render json: Megatron.style(
      series_params[:name], style_params[:name],
      province, city
    ), scope: nil
  end

  def easy_config
    configs = YAML.load_file("#{Rails.root}/config/easy_config.yml")
    result = configs.each_with_object([]) do |(key, value), arr|
      arr << { key => value.keys }
    end

    render json: { data: result },
           scope: nil
  end

  def scope
    raise "You have to override this method."
  end

  private

  %w(brand series style).each do |key|
    define_method "#{key}_params" do
      params.require(key)
    end
  end

  def province
    return params[:region][:province] if params[:region]

    begin
      scope.province
    rescue
      ""
    end
  end

  def city
    return params[:region][:city] if params[:region]

    begin
      scope.city
    rescue
      ""
    end
  end
end
