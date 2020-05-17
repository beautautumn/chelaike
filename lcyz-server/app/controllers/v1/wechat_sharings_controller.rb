module V1
  class WechatSharingsController < ApplicationController
    serialization_scope :current_seller

    before_action :skip_authorization
    skip_before_action :authenticate_user!, only: [:show, :index, :allied_show]

    def show
      car = Car.find(params[:car_id])

      render json: car,
             serializer: CarSerializer::WechatDetail,
             root: "data"
    end

    def allied_show
      car = Car.find(params[:car_id])

      render json: car,
             serializer: CarSerializer::WechatAllianceDetail,
             root: "data"
    end

    def index
      company_id = current_seller.try(:company_id) || params[:company_id]

      cars = paginate Car
             .where(company_id: company_id, sellable: true, reserved: false)
             .state_in_stock_scope
             .ransack(params[:query]).result
             .order("id desc")

      render json: cars.includes(:images),
             meta: {
               company: current_company.slice(:name, :contact_mobile, :logo, :id)
             },
             each_serializer: CarSerializer::WechatList,
             root: "data"
    end

    private

    def current_seller
      User.find(params[:seller_id]) if params[:seller_id]
    end

    def current_company
      current_seller.try(:company) || Company.find(params[:company_id])
    end
  end
end
