module Open
  module V1
    class OnlineEstimationsController < Open::ApplicationController
      def new
        estimation = OnlineEstimation.create(online_estimation_params)
        estimation.transfer_to_acquisition_info(current_company)

        render json: { message: :ok }, scope: nil
      end

      private

      def online_estimation_params
        params.require(:online_estimation).permit(
          :brand_name, :series_name, :style_name, :licensed_at,
          :mileage, :customer_phone
        )
      end
    end
  end
end
