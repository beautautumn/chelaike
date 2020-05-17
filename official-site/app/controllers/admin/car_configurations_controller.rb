# frozen_string_literal: true
class Admin::CarConfigurationsController < Admin::ApplicationController
  def show
    @car_configuration = if @tenant.car_configuration.present?
                           @tenant.car_configuration
                         else
                           CarConfiguration.new
                         end
  end

  def update
    @car_configuration = if @tenant.car_configuration.present?
                           @tenant.car_configuration
                         else
                           @tenant.create_car_configuration
                         end
    @car_configuration.reload
    @car_configuration.update_attributes(car_configuration_params)

    redirect_to admin_tenant_car_configuration_path
  end

  private

  def deal_down_payments(values)
    return [] unless values[:down_payments].try(:size)
    values[:down_payments].select(&:present?)
                          .map(&:to_i)
                          .sort
  end

  def deal_loan_periods(values)
    return [] unless values[:loan_periods].try(:size)
    ret = values[:loan_periods].select { |v| v["period"].present? }.map do |v|
      {}.tap do |x|
        x["period"] = v["period"].to_i
        x["rate"] = v["rate"].to_f if v["rate"].present?
      end
    end
    ret.sort { |a, b| a["period"] <=> b["period"] }
  end

  def car_configuration_params
    values = params.require(:car_configuration)
                   .permit(:maintenance_price_cents,
                           :insurance_price_cents,
                           :default_loan,
                           down_payments: [],
                           loan_periods: [:period, :rate])
    {}.tap do |ret|
      ret[:default_loan] = values[:default_loan].to_i if values[:default_loan].present?

      ret[:down_payments] = deal_down_payments(values)

      ret[:loan_periods] = deal_loan_periods(values)
      ret[:insurance_price_cents] = (values[:insurance_price_cents].to_f * 100).to_i
      ret[:maintenance_price_cents] = (values[:maintenance_price_cents].to_f * 100).to_i
    end
  end
end
