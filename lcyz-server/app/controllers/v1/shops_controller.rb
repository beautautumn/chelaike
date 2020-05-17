module V1
  class ShopsController < ApplicationController
    before_action only: [:index, :query_city] do
      authorize Shop
    end

    def index
      render json: policy_scope(current_user.company.shops.order(id: :desc)),
             each_serializer: ShopSerializer::Common,
             root: "data"
    end

    def create
      shop = Shop.where(company_id: current_user.company_id).new(shop_params)
      authorize shop

      shop.save

      if shop.errors.empty?
        render json: shop,
               serializer: ShopSerializer::Common,
               root: "data"
      else
        validation_error(full_errors(shop))
      end
    end

    def update
      shop = Shop.where(company_id: current_user.company_id).find(params[:id])
      authorize shop

      shop.update(shop_params)

      if shop.errors.empty?
        render json: shop,
               serializer: ShopSerializer::Common,
               root: "data"
      else
        validation_error(full_errors(shop))
      end
    end

    def destroy
      shop = current_user.company.shops.find(params[:id])
      authorize shop

      render json: shop.destroy,
             serializer: ShopSerializer::Common,
             root: "data"
    end

    def query_city
      city = params[:city]

      shops = if city.present?
                current_user.company.shops.where(city: city)
              else
                []
              end

      render json: shops,
             each_serializer: ShopSerializer::Common,
             root: "data"
    end

    private

    def shop_params
      params.require(:shop).permit(:name, :address, :phone, :province, :city)
    end
  end
end
