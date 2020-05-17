module Open
  module V1
    class CompaniesController < Open::ApplicationController
      def show
        render json: current_company,
               serializer: CompanySerializer::Youhaosuda,
               root: "data",
               meta: { version_catagory: version_catagory }
      end

      def update
        current_company.update_columns(company_params)

        render json: current_company,
               serializer: CompanySerializer::Youhaosuda,
               root: "data"
      end

      def banners
        render json: { data: current_company.banners }, scope: nil
      end

      def qrcode
        render json: { data: current_company.qrcode }, scope: nil
      end

      private

      def company_params
        params.require(:company).permit(:youhaosuda_shop_token)
      end
    end
  end
end
