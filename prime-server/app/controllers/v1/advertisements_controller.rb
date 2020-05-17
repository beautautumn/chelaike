class V1::AdvertisementsController < ApplicationController
  before_action :skip_authorization

  def index
    render json: Advertisement.where(state: "enabled"),
           each_serializer: AdvertisementSerializer::Common,
           root: "data"
  end
end
