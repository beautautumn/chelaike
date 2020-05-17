class PriceTagsController < ApplicationController
  before_action :skip_authorization
  skip_before_action :authenticate_user!

  def show
    @car = Car.find(params[:car_id])
    @company = @car.company

    price_tag_template = PriceTagTemplate.where(
      company_id: @company.id,
      current: true
    ).first

    render text: price_tag_html(price_tag_template)
  end

  private

  def price_tag_html(price_tag_template)
    return "请上传价签模板" if price_tag_template.blank?

    Liquid::Template.parse(price_tag_template.code)
                    .render(available_variables)
  rescue StandardError => e
    ExceptionNotifier.notify_exception(e) if Rails.env.production?

    <<-TEXT.strip_heredoc
      价签模板语法错误

      #{e.message}
    TEXT
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def available_variables
    acquisition_transfer = @car.acquisition_transfer

    {
      car_id: @car.id,
      company_name: @company.try(:name),
      company_logo: @company.try(:logo),
      car_brand_name: @car.brand_name,
      car_series_name: @car.series_name,
      car_style_name: @car.style_name,
      car_cover_url: @car.cover_url,
      car_name: "#{@car.series_name} #{@car.style_name}",
      car_fuel_type: @car.fuel_type_text,
      car_star_rating: @car.star_rating || 5,
      car_license_info: @car.license_info_text,
      car_licensed_at: @car.licensed_at.try { |d| d.strftime("%Y-%m") },
      car_mileage: @car.mileage,
      car_mileage_in_fact: @car.mileage_in_fact,
      car_displacement: @car.displacement_text,
      car_exterior_color: @car.exterior_color,
      car_interior_color: @car.interior_color,
      car_transmission: @car.transmission_text,
      car_qrcode: "#{ENV.fetch("SERVER_HOST")}/api/v1/cars/#{@car.id}/qrcode",
      car_acquisition_type: @car.acquisition_type,
      car_show_price_wan: @car.show_price_wan,
      car_new_car_final_price_wan: @car.new_car_final_price_wan,
      car_sales_minimun_price_wan: @car.sales_minimun_price_wan,
      car_allowed_mortgage: @car.allowed_mortgage,
      car_mortgage_note: @car.mortgage_note,
      car_configuration_note: @car.configuration_note,
      car_selling_point: @car.selling_point,
      company_street: @company.try(:street),
      car_contact_mobile: @company.try(:contact_mobile),
      car_vin: (@car.vin && @car.vin.size > 6) ? @car.vin[-6..-1] : @car.vin,
      car_manufactured_at: @car.manufactured_at,
      car_type: @car.car_type_text,
      car_is_fixed_price: @car.is_fixed_price,
      car_emission_standard: @car.emission_standard_text,
      car_stock_number: @car.stock_number,
      car_commercial_insurance: acquisition_transfer.try(:commercial_insurance),
      car_commercial_insurance_end_at: acquisition_transfer.try(:commercial_insurance_end_at),
      car_commercial_insurance_amount_yuan: acquisition_transfer
        .try(:commercial_insurance_amount_yuan),
      car_compulsory_insurance_end_at: acquisition_transfer.try(:compulsory_insurance_end_at),
      car_usage_type: acquisition_transfer.try(:usage_type_text),
      car_annual_inspection_end_at: acquisition_transfer.try(:annual_inspection_end_at),
      car_key_count: acquisition_transfer.try(:key_count) || 0,
      car_manufacturer_configuration: @car.manufacturer_configuration_hash,
      company_slogan: @company.slogan,
      car_new_car_guide_price_wan: @car.new_car_guide_price_wan,
      car_interior_note: @car.interior_note,
      car_second_image_url: @car.images.second.try(:url)
    }.stringify_keys
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
