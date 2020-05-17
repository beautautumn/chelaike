# frozen_string_literal: true
module SellerFilter
  extend ActiveSupport::Concern

  def current_seller
    return unless params[:seller_id]
    begin
      @seller = Chelaike::SellerService.fetch_seller_info(params[:seller_id], @tenant.company_id)
    rescue RestClient::NotFound
      nil
    end
    return @seller
  end
end
