#!/usr/bin/env ruby
# encoding: utf-8
module Che3bai
  class LoanService
    def brands
      get_data("getCarBrandList") do
        "che300_loan:brands"
      end
    end

    def brand_id(name)
      response = get_data("getCarBrandList") do
        "che300_loan:brands:#{name}"
      end

      response["brand_list"].find { |brand| brand["brand_name"] == name }.fetch("brand_id")
    end

    def serieses(brand_id)
      get_data("getCarSeriesList", brandId: brand_id) do
        "che300_loan:serieses:#{brand_id}"
      end
    end

    def series_id(name, brand_id)
      response = get_data("getCarSeriesList", brandId: brand_id) do
        "che300_loan:series:#{name}"
      end

      response["series_list"].find { |series| series["series_name"] == name }.fetch("series_id")
    end

    def models(series_id)
      get_data("getCarModelList", seriesId: series_id) do
        "che300_loan:models:#{series_id}"
      end
    end

    def model_id(name, series_id)
      response = get_data("getCarModelList", seriesId: series_id) do
        "che300_loan:models:#{name}"
      end

      response["model_list"].find { |series| series["model_name"] == name }.fetch("model_id")
    end

    def cities
      get_data("getAllCity") do
        "che300_loan:cities"
      end
    end

    def city(name)
      response = get_data("getAllCity") do
        "che300_loan:city:#{name}"
      end

      response["city_list"].find { |city| name.start_with?(city["city_name"]) }.fetch("city_id")
    end

    def estimate(model_id, reg_date, mile, zone)
      get_data("getUsedCarPrice", modelId: model_id, regDate: reg_date, mile: mile, zone: zone) do
        "che300_loan:estimate:#{model_id}"
      end
    end

    def model_by_vin(vin)
      path = "identifyModelByVIN"
      params = { vin: vin }
      get_data(path, params)
    end

    protected

    def get_data(path, params = nil)
      response = if block_given?
                   Rails.cache.fetch(yield) { String.new(send_request(path, params)) }
                 else
                   send_request(path, params)
                 end
      return MultiJson.load(response)
    rescue StandardError
      { state: 400, message: "Request che300 data error" }
    end

    def send_request(path, params = {})
      query = params.to_h.merge(token: ENV.fetch("CHE_300_TOKEN")).to_query
      Util::Request.get("#{ENV.fetch("CHE_300_BASE_URL")}/#{path}?#{query}", open_timeout: 5)
    end
  end
end
