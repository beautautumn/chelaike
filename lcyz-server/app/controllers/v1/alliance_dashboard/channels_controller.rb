# 联盟公司的渠道
module V1
  module AllianceDashboard
    class ChannelsController < V1::AllianceDashboard::ApplicationController
      before_action do
        authorize Channel
      end

      def index
        render json: channel_scope.order(id: :desc),
               each_serializer: ChannelSerializer::Common,
               root: "data"
      end

      def create
        channel = current_user.alliance_company.channels.create(
          channel_params
        )

        if channel.errors.empty?
          render json: channel,
                 serializer: ChannelSerializer::Common,
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
                 serializer: ChannelSerializer::Common,
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

      def company_index
        channels = Channel.where(company_id: params[:id], company_type: "Company")

        render json: channels.order(id: :desc),
               each_serializer: ChannelSerializer::Common,
               root: "data"
      end

      private

      def channel_params
        params.require(:channel).permit(:name, :note)
      end

      def channel_scope
        Channel.where(company_id: current_user.company_id, company_type: "AllianceCompany::Company")
      end
    end
  end
end
