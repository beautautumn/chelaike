module Dashenglaile
  class Brand
    extend Dashenglaile::Request

    BRAND_CACHE_KEY = "dashenglaile:brand".freeze

    def self.get(company: nil)
      Rails.cache.fetch(cache_key(company), expires_in: 10.minutes) do
        result = dasheng_post(sign: false, interface: "get_available_car_brands_list")
        result.each do |brand|
          change_price(brand, company)
        end
      end
    end

    def self.brand_info(vin)
      return nil if vin.blank? || vin.start_with?("http")
      dasheng_post(
        sign: true,
        interface: "get_brand_info",
        vin: vin
      )
    end

    def self.brand_price(brand_id: nil, company: nil)
      brands = get(company: company)
      price = brands.find { |b| b["brand_id"].to_i == brand_id }.try(:[], "brand_price")
      price || MaintenanceSetting.instance.dashenglaile_unit_price.to_i
    end

    def self.change_price(brand, company)
      price = "29".freeze
      brand["brand_price"] = if company && company.active_tag && brand["brand_price"] == price
                               MaintenanceSetting.instance.dashenglaile_unit_price.to_i
                             else
                               brand["brand_price"].to_i
                             end
    end

    def self.cache_key(company)
      if company && company.active_tag
        "dashenglaile:brand:#{company.id}"
      else
        BRAND_CACHE_KEY
      end
    end

    def self.working_hours(brand_id:)
      brand = get.find { |b| b["brand_id"].to_i == brand_id }
      return [{ hour: 9, min: 0 }, { hour: 18, min: 0 }] unless brand.present?
      start_hour, start_min = brand["query_start_time"].split(":").map(&:to_i)
      end_hour, end_min = brand["query_end_time"].split(":").map(&:to_i)
      [{ hour: start_hour, min: start_min },
       { hour: end_hour, min: end_min }].freeze
    end
  end
end
