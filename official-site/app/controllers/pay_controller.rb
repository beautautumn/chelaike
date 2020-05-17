# frozen_string_literal: true
class PayController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index, :pay, :notify]
  skip_before_action :current_tenant, only: [:index, :pay, :notify]
  change_view_by_device
  before_action :set_car, only: [:create]

  def index
    @tenant = Tenant.find(pay_params[:tenant_id])
    car = Chelaike::CarService.find(params[:car], @tenant.company_id)
    @url = "http://#{@tenant.subdomain}.#{ENV.fetch("SERVER_HOST")}/#{car_path(car.id)}"
    @token = params[:token]
  end

  def create
    pay_hash = pay_data params[:token]
    ActiveRecord::Base.transaction do
      @order = Order.create!(
        order_no: Time.zone.now.to_i,
        amount_cents: pay_hash.fetch("price").to_i,
        channel: "wx_pub_qr",
        currency: "cny",
        client_ip: "127.0.0.1",
        tenant: @tenant,
        app_id: ENV.fetch("PINGPP_APP_ID"),
        product_id: "#{@car.id}_#{Time.zone.now.to_i}",
        status: "charge",
        subject: params[:orderable_type] == "EvaluateReport" ? "购买维保报告" : "购买保险报告",
        body: "订单内容",
        orderable_id: pay_hash.fetch("orderable_id"),
        orderable_type: pay_hash.fetch("orderable_type")
      )

      @charge_response = Pingpp::Charge.create(
        order_no: @order.order_no,
        amount: @order.amount_cents,
        subject: @order.subject,
        body: @order.body,
        channel: @order.channel,
        currency: @order.currency,
        client_ip: @order.client_ip,
        app: { id: @order.app_id },
        extra: {
          product_id: @order.product_id
        }
      )
      qr_code_url = @charge_response["credential"]["wx_pub_qr"]
      @order.update_attributes(qr_code_url: qr_code_url) if qr_code_url
    end

    @pay_token = Wechat::DesktopAuth.encode
    Rails.cache.write(@pay_token, @order&.qr_code_url, expires_in: 10.minutes )
    @qr_code = @order.qr_code_url
    # @qr_code = Order.last.qr_code_url
  end

  def pay_result_query
    qr_code_url = Rails.cache.read(params[:token])
    order = Order.find_by_qr_code_url(qr_code_url)
    if order&.status == "success"
      render json: { content: "payed", status: 200}
    else
      render json: { content: "nothing", status: 400}
    end

  end

  def pay
    pay_hash = Hash.new
    pay_data_string = Wechat::DesktopAuth.parse_token params[:token]

    pay_data_string.split(";").each do |item|
      item_arrary = item.split("=")
      pay_hash[item_arrary[0]] = item_arrary[1]
    end

    @tenant = Tenant.find(pay_hash["tenant_id"])
    @order = Order.create!(
      order_no: Time.zone.now.to_i,
      amount_cents: pay_hash.fetch("price").to_i,
      channel: "wx_pub",
      currency: "cny",
      client_ip: request.remote_ip,
      tenant: @tenant,
      app_id: ENV.fetch("PINGPP_APP_ID"),
      open_id: pay_hash["open_id"],
      status: "charge",
      subject: "购买报告",
      body: "订单内容",
      orderable_id: pay_hash.fetch("orderable_id"),
      orderable_type: pay_hash.fetch("orderable_type")
    )

    pay_type = pay_hash.fetch("orderable_type") == "MaintenanceRecord" ? "MaintenanceRecord" : "InsuranceRecord"
    report_record = pay_type.constantize.find(pay_hash.fetch("orderable_id"))
    car = Chelaike::CarService.find(report_record.car_id, @tenant.company_id)

    @charge_response = Pingpp::Charge.create(
      order_no: @order.order_no,
      amount: @order.amount_cents,
      subject: @order.subject,
      body: @order.body,
      channel: @order.channel,
      currency: @order.currency,
      client_ip: @order.client_ip,
      app: { id: @order.app_id },
      extra: { open_id: @order.open_id },
      metadata: {
        record_url: "http://#{@tenant.subdomain}.#{ENV.fetch("SERVER_HOST")}/cars/#{car.id}/#{pay_hash.fetch("orderable_type").split("Record")[0].downcase}_detail"
      }
    )
    render json: @charge_response
  end

  def notify
    head :unauthorized if request.headers["HTTP_X_PINGPLUSPLUS_SIGNATURE"].nil?

    raw_data = request.body.read
    signature = request.headers["HTTP_X_PINGPLUSPLUS_SIGNATURE"]

    pub_key_path = Rails.root.to_s + "/config/pingpp/pingpp_rsa_public_key.pem"
    if verify_signature(raw_data, signature, pub_key_path)
      event_process
    else
      head :forbidden
    end
  end

  private

  def pay_data encrypt_token
    pay_hash = Hash.new
    pay_data_string = Wechat::DesktopAuth.parse_token encrypt_token

    pay_data_string.split(";").each do |item|
      item_arrary = item.split("=")
      pay_hash[item_arrary[0]] = item_arrary[1]
    end
    return pay_hash
  end

  def set_car
    @car = Chelaike::CarService.find(params[:car_id], @tenant.company_id)
  end

  def event_process
    status = 400
    response_body = ""
    begin
      case params[:type]
      when nil
        response_body = "Event 对象中缺少 type 字段"
      when "charge.succeeded"
        order_success
        status = 200
        response_body = "OK"
      else
        response_body = "未知 Event 类型"
      end
    rescue JSON::ParserError
      response_body = "JSON 解析失败"
    end
    render status: status, text: response_body
  end

  def verify_signature(raw_data, signature, pub_key_path)
    rsa_public_key = OpenSSL::PKey.read(File.read(pub_key_path))
    rsa_public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), raw_data)
  end

  def order_success
    order_no = params[:data][:object][:order_no]
    open_id = params[:data][:object][:extra][:open_id]
    Rails.logger.info "ORDER: #{order_no}"
    Order.find_by(order_no: order_no)&.update!(status: :success, open_id: open_id)
  end

  def pay_params
    params.permit(:tenant_id, :orderable_id, :orderable_type, :open_id, :previous_url, :id)
  end
end
