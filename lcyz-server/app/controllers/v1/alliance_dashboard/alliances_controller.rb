module V1
  module AllianceDashboard
    class AlliancesController < V1::AllianceDashboard::ApplicationController
      before_action :find_alliance

      def show
        render json: @alliance,
               alliance_company: current_company,
               serializer: AllianceDashboardSerializer::AllianceSerializer::Common,
               root: "data"
      end

      def update
        authorize @alliance
        @alliance.update(alliance_params)
        current_company.update(company_params)

        render json: @alliance,
               alliance_company: current_company,
               serializer: AllianceDashboardSerializer::AllianceSerializer::Common,
               root: "data"
      end

      private

      def company_params
        original_params.slice(
          :contact, :contact_mobile, :city, :province,
          :district, :water_mark,
          :water_mark_position
        )
      end

      def alliance_params
        original_params.slice(:name, :note, :avatar)
      end

      def original_params
        @_original_params ||= params.require(:alliance).permit(
          :name, :note, :avatar,
          :contact, :contact_mobile, :city, :province,
          :district, :water_mark,
          water_mark_position: [:p, :x, :y]
        )
      end

      def find_alliance
        @alliance = current_company.alliance
      end

      def current_company
        @current_company ||= current_user.alliance_company
      end
    end
  end
end
