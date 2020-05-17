class QrcodesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :skip_authorization

  def show
    if request.referer && request.referer.start_with?("http")
      qrcode = RQRCode::QRCode.new(params[:content])
      self.content_type = "image/png"
      self.response_body = qrcode.as_png(size: 300).to_s
    else
      url = CGI.unescape(params[:content])
      redirect_to url, status: 302
    end
  end
end
