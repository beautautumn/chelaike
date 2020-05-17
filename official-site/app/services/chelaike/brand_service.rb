# frozen_string_literal: true
module Chelaike
  class BrandService
    def self.fetch_brands(company_id)
      Rails.cache.fetch("chelaike/brands/#{company_id}", expires_in: 1.hour) do
        data = Chelaike::FetchService.get("/brands?relative=true", company_id)
        data[:data]
      end
    end

    def self.fetch_series(brand_name, company_id, fetch_all = false)
      all_series = Rails.cache.fetch("chelaike/series/#{company_id}", expires_in: 1.hour) do
        data = Chelaike::FetchService.get("/brands/series?relative=true", company_id)
        data[:data]
      end
      return all_series if fetch_all
      return all_series.take(14) unless brand_name.present?
      all_series.select { |item| item.brand_name == brand_name }
    end
  end
end
