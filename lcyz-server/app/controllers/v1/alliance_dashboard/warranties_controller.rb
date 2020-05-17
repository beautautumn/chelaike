# 得到质保等级
module V1
  module AllianceDashboard
    class WarrantiesController < V1::AllianceDashboard::ApplicationController
      def index
        render json: warranty_scope.order(id: :desc),
               each_serializer: WarrantySerializer::Common,
               root: "data"
      end

      private

      def warranty_scope
        Warranty.where(company_id: params[:company_id])
      end
    end
  end
end
