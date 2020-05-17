module V1
  class AcquisitionCarCommentsController < ApplicationController
    before_action :find_acquisition_car_info
    before_action :skip_authorization

    def create
      service = AcquisitionCarInfoService::Comment.new(
        current_user, @info
      )

      service.create(acquisition_car_comment_params)

      if service.valid?
        render json: service.comment,
               serializer: AcquisitionCarCommentSerializer::Basic,
               root: "data"
      else
        validation_error(service.errors)
      end
    rescue AcquisitionCarInfoService::Comment::StateError => e
      validation_error(e.message)
    end

    private

    def find_acquisition_car_info
      @info = AcquisitionCarInfo.find(params[:acquisition_car_info_id])
    end

    def acquisition_car_comment_params
      params.require(:acquisition_car_comment).permit(
        :valuation_wan, :note_text, { note_audios: [:url, :duration] },
        :state, :cooperate, :is_seller
      )
    end
  end
end
