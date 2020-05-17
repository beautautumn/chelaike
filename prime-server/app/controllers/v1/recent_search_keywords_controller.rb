module V1
  class RecentSearchKeywordsController < ApplicationController
    before_action :skip_authorization

    def show
      param! :type, String,
             in: %w(
               cars_in_stock cars_out_of_stock prepare_records
               acquisition_transfers alliances allied_cars
               intentions customers
             )

      return not_found unless params[:type].present?
      service = Search::RecentKeywordsService.new(params[:type], current_user.id)

      render json: { data: service.all }, scope: nil
    end
  end
end
