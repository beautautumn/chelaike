#!/usr/bin/env ruby
# encoding: utf-8
require "rails_helper"

RSpec.describe Che3bai::LoanService do
  let(:loan_service_obj) { Che3bai::LoanService.new }

  context "brands" do
    it "get che300 all car brands" do
      VCR.use_cassette("easyloan/che300brands") do
        brands = loan_service_obj.brands
        expect(brands["status"]).to eq "1"
      end
    end

    it "get a brand id by brand_name" do
      VCR.use_cassette("easyloan/che300brand") do
        brand_id = loan_service_obj.brand_id("阿尔法·罗密欧")
        expect(brand_id).to eq "3"
      end
    end
  end

  context "series" do
    it "get che300 all car series" do
      VCR.use_cassette("easyloan/che300serieses") do
        serieses = loan_service_obj.serieses("1")
        expect(serieses["status"]).to eq "1"
      end
    end

    it "get a series id by series_name" do
      VCR.use_cassette("easyloan/che300series") do
        series_id = loan_service_obj.series_id("奥迪A3", "1")
        expect(series_id).to eq "5"
      end
    end
  end

  context "models" do
    it "get che300 all car models" do
      VCR.use_cassette("easyloan/che300models") do
        models = loan_service_obj.models("1")
        expect(models["status"]).to eq "1"
      end
    end
    it "get a model id by model name" do
      VCR.use_cassette("easyloan/che300model") do
        model_id = loan_service_obj.model_id("2017款 奥迪A4L Plus 40 TFSI 进取型", "1")
        expect(model_id).to eq "1128793"
      end
    end
  end

  context "cities" do
    it "get che300 all cities" do
      VCR.use_cassette("easyloan/che300cities") do
        cities = loan_service_obj.cities
        expect(cities["status"]).to eq "1"
      end
    end

    it "get city id by city name" do
      VCR.use_cassette("easyloan/che300city") do
        city_id = loan_service_obj.city("东莞")
        expect(city_id).to eq "367"
      end
    end
  end

  it "estimate price" do
    VCR.use_cassette("easyloan/che300estimate") do
      estimate = loan_service_obj.estimate("58", "2012-3", "4", "11")
      expect(estimate["status"]).to eq "1"
    end
  end
end
