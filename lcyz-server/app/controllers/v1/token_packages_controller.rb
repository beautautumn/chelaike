module V1
  class TokenPackagesController < ApplicationController
    before_action do
      authorize TokenPackage
    end

    def index
      packages = TokenPackage.all.order(balance: :asc)

      render json: packages, root: :data, each_serializer: TokenPackageSerializer::Basic
    end

    def buy
      param! :order, Hash do |o|
        o.param! :channel, String, required: true
        o.param! :token_type, String, required: true, default: :company
      end
      param! :id, Integer, required: true

      create_order
      charge_response = charge
      @order.update!(charge_id: charge_response[:id], status: :charge)
      render json: { data: charge_response }, scope: nil
    end

    def free_buy
      param! :order, Hash do |o|
        o.param! :channel, String, required: true
        o.param! :amount, Float, required: true
        o.param! :token_type, String, required: true, default: :company
      end

      create_order(true)
      charge_response = charge(true)
      @order.update!(charge_id: charge_response[:id], status: :charge)
      render json: { data: charge_response }, scope: nil
    end

    private

    def package
      @package ||= TokenPackage.where(id: params[:id]).first!
    end

    def order_params
      params.require(:order).permit(:channel, :token_type)
    end

    def free_buy_params
      params.require(:order).permit(:channel, :amount, :token_type)
    end

    def create_order(free_buy = false)
      if free_buy
        @order = Order.new
        @order.channel = free_buy_params[:channel]
        @order.amount_cents = free_buy_params[:amount] * 100
        @order.action = :token
      else
        @order = Order.new(order_params)
        @order.amount_cents = package.price_cents
        @order.orderable = package
        @order.quantity = 1
        @order.action = :token_package
      end
      @order.assign_attributes(
        client_ip: request.remote_ip,
        currency: "cny",
        status: :init,
        shop_id: current_user.shop_id,
        company_id: current_user.company_id,
        user_id: current_user.id,
        token_type: params[:order][:token_type]
      )
      @order.save!
    end

    def charge(free_buy = false)
      Pingpp::Charge.create(
        order_no: @order.id,
        app: { id: pingpp_key },
        channel: @order.channel,
        amount: @order.amount_cents,
        client_ip: request.remote_ip,
        currency: "cny",
        subject: "车币充值",
        body: (free_buy ? "#{free_buy_params[:amount]}车币" : package.name)
      )
    end

    def pingpp_key
      if app_store_request?
        ENV.fetch("PINGPP_STORE_APP_ID")
      else
        ENV.fetch("PINGPP_APP_ID")
      end
    end

    def app_store_request?
      app_key = request.headers["AutobotsAppKey"].try(:downcase)
      return unless app_key
      app_key == "chelaike-app-store"
    end
  end
end
