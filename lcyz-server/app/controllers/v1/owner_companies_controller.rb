module V1
  class OwnerCompaniesController < ApplicationController
    before_action do
      authorize OwnerCompany
    end
    before_action :find_company, only: [:show, :update, :destroy]

    def index
      query = params[:query]

      will_paginate = params[:page]

      companies = OwnerCompany.where(company_id: current_user.company_id)
                              .ransack(query).result

      companies = paginate companies if will_paginate

      render json: companies,
             each_serializer: OwnerCompanySerializer::Common,
             root: "data"
    end

    def show
      render json: @company,
             serializer: OwnerCompanySerializer::Common,
             root: "data"
    end

    def create
      company = OwnerCompany.create(
        owner_company_params.merge(company_id: current_user.company_id)
      )
      render json: company,
             serializer: OwnerCompanySerializer::Common,
             root: "data"
    end

    def update
      @company.update!(
        owner_company_params.merge(company_id: current_user.company_id)
      )
      render json: @company,
             serializer: OwnerCompanySerializer::Common,
             root: "data"
    end

    def destroy
      render json: @company.destroy,
             serializer: OwnerCompanySerializer::Common,
             root: "data"
    end

    def query
      query = params[:query]

      companies = if query.present?
                    OwnerCompany.where(company_id: current_user.company_id)
                                .ransack(query).result
                  else
                    []
                  end

      render json: companies,
             each_serializer: OwnerCompanySerializer::Common,
             root: "data"
    end

    # 根据shop_id得到相应归属车商
    def query_shop
      shop_id = params[:shop_id]
      companies = if shop_id.present?
                    OwnerCompany.where(
                      company_id: current_user.company_id,
                      shop_id: shop_id)
                  else
                    []
                  end

      render json: companies,
             each_serializer: OwnerCompanySerializer::Common,
             root: "data"
    end

    private

    def owner_company_params
      params.require(:owner_company).permit(:name, :shop_id)
    end

    def find_company
      @company = OwnerCompany.find(params[:id])
    end
  end
end
