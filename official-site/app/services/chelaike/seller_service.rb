# frozen_string_literal: true
module Chelaike
  class SellerService
    def self.fetch_seller_info(id, company_id)
      Rails.cache.fetch("chelaike/seller_info/#{id}", expires_in: 5.minutes) do
        data = Chelaike::FetchService.get("/users/#{id}", company_id)
        data[:data]
      end
    end
  end
end
