# frozen_string_literal: true
module Chelaike
  class ShopService
    class << self
      def fetch_shop_info(company_id, id)
        Rails.cache.fetch(shop_cache_key(id), expires_in: 1.hour) do
          data = Chelaike::FetchService.get("/companies/#{company_id}/shops/#{id}")
          data[:data]
        end
      end

      def delete_company_cache(id)
        Rails.cache.delete(shop_cache_key(id))
      end

      private

      def shop_cache_key(id)
        "chelaike/shop_info/#{id}"
      end

    end
  end
end
