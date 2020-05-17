module V1
  class ChannelsController < ApplicationController
    before_action do
      authorize Channel
    end

    def index
      render json: channel_scope.order(id: :desc),
             each_serializer: ChannelSerializer::WechatQrcode,
             root: "data"
    end

    def create
      channel = channel_scope.create(channel_params)

      if channel.errors.empty?
        render json: channel,
               serializer: ChannelSerializer::WechatQrcode,
               root: "data"
      else
        validation_error(full_errors(channel))
      end
    end

    def update
      channel = channel_scope.find(params[:id])
      channel.update(channel_params)

      if channel.errors.empty?
        render json: channel,
               serializer: ChannelSerializer::WechatQrcode,
               root: "data"
      else
        validation_error(full_errors(channel))
      end
    end

    def destroy
      render json: channel_scope.find(params[:id]).destroy,
             serializer: ChannelSerializer::Common,
             root: "data"
    end

    private

    def channel_params
      params.require(:channel).permit(:name, :note)
    end

    def channel_scope
      Channel.where(company_id: current_user.company_id, company_type: "Company")
    end

    def current_company
      @company ||= current_user.company
    end
  end
end
