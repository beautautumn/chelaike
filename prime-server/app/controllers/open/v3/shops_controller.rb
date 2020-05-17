module Open
  module V3
    class ShopsController < V3::ApplicationController
      # 根据条件得到所有车商列表
      def index
        companies_scope = Company.all.order(id: :desc)

        companies = companies_scope.ransack(params[:query]).result

        render json: companies,
               each_serializer: CompanySerializer::CheRongYi,
               root: "data"
      end

      def show
        company = Company.find(params[:id])

        render json: company,
               serializer: CompanySerializer::CheRongYi,
               root: "data"
      end

      # 得到所有company_ids的在库车辆信息
      def all_cars
        company_ids = params[:company_ids]
        companies = Company.includes(cars: [:acquisition_transfer, :sale_transfer,
                                            :operation_records, :prepare_record,
                                            :images, :operation_records]).where(id: company_ids)

        render json: companies, company_domain_hash: {},
               each_serializer: CompanySerializer::SyncCheRongYi,
               root: "data"
      end

      # 根据车商ID得到它里面所有的分店信息
      def shops_by_company
        company = Company.find(params[:id])
        shops = company.shops

        render json: shops,
               each_serializer: ShopSerializer::Common,
               root: "data"
      end

      # 设置一个车商为已授信
      def update_accredited
        company = Company.find(params[:id])
        company.update!(accredited: true)

        render json: company,
               serializer: CompanySerializer::CheRongYi,
               root: "data"
      end
    end
  end
end
