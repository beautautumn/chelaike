module Open
  module V2
    class AlliancesController < Open::ApplicationController
      def index
        param! :query, Hash
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 15

        alliances = paginate Alliance.all
                    .includes(owner: :owner)
                    .ransack(params[:query]).result
                    .order(id: :desc)

        render json: alliances,
               each_serializer: AllianceSerializer::Common,
               root: "data"
      end

      def show
        alliance = Alliance.find(params[:id])

        render json: alliance,
               serializer:  AllianceSerializer::Detail,
               root: "data"
      end
    end
  end
end
