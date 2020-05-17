# frozen_string_literal: true
module Chelaike
  class CompanyService
    class << self
      def fetch_company_info(id)
        Rails.cache.fetch(company_cache_key(id), expires_in: 1.hour) do
          data = Chelaike::FetchService.get("/companies/#{id}")
          data[:data]
        end
      end

      def delete_company_cache(id)
        Rails.cache.delete(company_cache_key(id))
      end

      # 这个商家所在联盟的主站ID
      def alliance_owner_info(company_id)
        Rails.cache.fetch(company_alliance_cache_key(company_id), expires_in: 10.minutes) do
          result = Chelaike::FetchService.get("/companies/#{company_id}/alliance_owner_company")
          result[:data] # data: { owner_id: 456, alliance_name: "abc", cars_count: 1234 }
        end
      end

      def alliance_members(company_id)
        Rails.cache.fetch(alliance_members_cache_key(company_id), expires_in: 1.hour) do
          result = Chelaike::FetchService.get("/companies/#{company_id}/alliance_members")
          result[:data]
        end
      end

      private

      def company_cache_key(id)
        "chelaike/company_info/#{id}"
      end

      def company_alliance_cache_key(id)
        "chelaike/company_alliance_main_id/#{id}"
      end

      def alliance_members_cache_key(id)
        "chelaike/alliance_members_main_id/#{id}"
      end
    end
  end
end
