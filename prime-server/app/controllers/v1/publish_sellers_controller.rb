module V1
  class PublishSellersController < ApplicationController
    before_action :skip_authorization
    before_action :find_che168_profile

    def index
      sellers = if @che168_profile
                  CarPublisher::Che168Worker::Helper.sellers(@che168_profile.data["cookies"])
                else
                  []
                end

      render json: { data: sellers }, scope: nil
    end

    private

    def current_company
      current_user.company
    end

    def find_che168_profile
      @che168_profile = current_company.che168_profile
    end
  end
end
