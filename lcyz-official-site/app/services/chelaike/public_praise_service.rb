# frozen_string_literal: true
module Chelaike
  class PublicPraiseService
    class << self
      def fetch_sumup(car_id)
        Rails.cache.fetch("chelaike/public_praise_sumup/#{car_id}", expires_in: 1.hour) do
          Chelaike::FetchService.get("/public_praises/sumup?car_id=#{car_id}")
        end
      end

      def fetch_public_praises(params)
        Chelaike::FetchService.get("/public_praises", nil, params)
      end
    end
  end
end
