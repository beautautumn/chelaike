class Car < ActiveRecord::Base
  class Che3baoService
    def initialize(company_id, search_params)
      @search_params = search_params

      fetch_company_ids(company_id)
    end

    def execute
      Car.where(company_id: @company_ids)
         .public_send(stock_type)
         .ransack(ransack_params)
         .result
         .order(order_param)
    end

    private

    def ransack_params
      {
        shop_id_eq: @search_params[:storeId],
        brand_name_cont: @search_params[:brandName],
        series_name_cont: @search_params[:seriesName],
        name_cont: @search_params[:catalogueName],
        show_price_cents_gteq: show_price_cents_gteq,
        show_price_cents_lteq: show_price_cents_lteq,
        age_gteq: @search_params[:carAgeLow],
        age_lteq: @search_params[:carAgeHigh],
        mileage_gteq: @search_params[:mileageLow],
        mileage_lteq: @search_params[:mileageHigh],
        created_at_gteq: @search_params[:instockDateLow],
        created_at_lteq: @search_params[:instockDateHigh],
        displacement_gteq: @search_params[:ovLow],
        displacement_lteq: @search_params[:ovHigh],
        exterior_color_cont: @search_params[:carColor],
        car_type_cont: car_type,
        cover_url_null: show_cover_tag,
        updated_at_gteq: @search_params[:updated_at_gteq]
      }.merge(show_price_tag)
    end

    def show_price_cents_gteq
      return if @search_params[:priceLow].blank?

      @search_params[:priceLow].to_i * 1_000_000
    end

    def show_price_cents_lteq
      return if @search_params[:priceHigh].blank?

      @search_params[:priceHigh].to_i * 1_000_000
    end

    def car_type
      return nil unless @search_params[:carType]

      %w(micro_car compact_car mid_size_car full_size_car mpv suv sports_car
         pickup_trucks)[@search_params[:carType].to_i]
    end

    def stock_type
      %w(all state_in_stock_scope state_out_of_stock_scope)[@search_params[
        :stockState].to_i]
    end

    def show_cover_tag
      case @search_params[:showHasPic].to_i
      when 0
        nil
      when 1
        0
      end
    end

    def show_price_tag
      case @search_params[:showNoPrice].to_i
      when 0
        {}
      when 1
        { show_price_cents_null: 0 }
      when 2
        { show_price_cents_null: 1 }
      end
    end

    def order_param
      options = {
        "default" => "",
        "price_low" => "show_price_cents asc",
        "price_high" => "show_price_cents desc",
        "mileage_low" => "mileage asc",
        "mileage_high" => "mileage desc",
        "register_low" => "licensed_at asc",
        "register_high" => "licensed_at desc"
      }
      options[@search_params[:sortBy]]
    end

    def fetch_company_ids(company_id)
      @company_ids = [company_id]

      return unless @search_params[:company_ids]
      @company_ids.concat(@search_params[:company_ids].split(",").map(&:to_i))
    end
  end
end
