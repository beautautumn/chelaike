module V1
  class PriceTagTemplatesController < ApplicationController
    before_action :skip_authorization

    def create
      @service = PriceTagTemplate::CreateService.new(
        current_user, params[:file].path, params[:file].original_filename, params
      ).execute

      render json: { data: { id: @service.price_tag_template.id } }, scope: nil
    end
  end
end
