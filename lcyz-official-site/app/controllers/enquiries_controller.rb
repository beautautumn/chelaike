# frozen_string_literal: true
# 询价
class EnquiriesController < ApplicationController
  change_view_by_device
  ensure_wechat_login
  # skip_before_action :verify_authenticity_token, only: [:like]
  skip_before_action :verify_authenticity_token

  def create
    return render json: { data: "ok" } unless @current_user
    wechat_user = @current_user.wechat_user

    enquiry = Enquiry.new(
      enquiry_params.merge(wechat_user_id: wechat_user.id, tenant_id: @tenant.id)
    )

    wechat_user&.update!(phone: enquiry.phone)

    respond_to do |format|
      if enquiry.save
        format.json { render json: { data: "ok" } }
      else
        format.json {}
      end
    end

    company_id = current_tenant.company_id
    Chelaike::CarService.subscribe(company_id, enquiry_params)
  end

  def index; end

  private

  def enquiry_params
    params.require(:enquiry).permit(:car_id, :phone, :name)
  end
end
