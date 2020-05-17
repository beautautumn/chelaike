module Open
  module V2
    class CompaniesController < Open::ApplicationController
      def index
        param! :query, Hash
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 15

        companies = paginate Company.all
                    .includes(:owner)
                    .ransack(params[:query]).result
                    .order(id: :desc)

        render json: companies,
               each_serializer: CompanySerializer::Open,
               root: "data"
      end

      def show
        company = Company.find(params[:id])

        render json: company,
               serializer: CompanySerializer::Open,
               root: "data"
      end

      # 得到这个商家所在联盟的主站商家id及联盟名称
      def alliance_owner_company
        company = Company.find(params[:company_id])
        alliance = company.open_alliance

        owner_id = alliance.try(:owner).try(:id)

        alliance_info = {
          owner_id: owner_id,
          alliance_name: alliance.try(:name),
          cars_count: alliance.try(:cars_count)
        }

        render json: { data: alliance_info },
               scope: nil
      end

      # 取得联盟下属所有参与公司
      def alliance_members
        alliance = Alliance.find_by "owner_id = ? and alliance_company_id is not null",
                                    params[:company_id]
        companies = if alliance
                      alliance.companies.where.not("companies.id = ?", params[:company_id])
                    else
                      []
                    end
        render json: companies,
               each_serializer: CompanySerializer::Open,
               root: "data"
      end

      # 得到一家公司里的所有分店
      def shops
        company = Company.find(params[:company_id])
        render json: company.shops,
               each_serializer: ShopSerializer::Common,
               root: "data"
      end
    end
  end
end
