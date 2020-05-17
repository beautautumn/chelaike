class UtilController < ApplicationController
  serialization_scope :anonymous

  skip_before_action :authenticate_user!
  before_action :skip_authorization

  def image_base64
    base64 = Util::Image.base64(params[:url])

    render json: { data: { image_base64: base64 } }, scope: nil
  end

  def shortener
    # 官网查询条件, 需要二次 URI encode
    content = if params[:q].present?
                params[:q]
              else
                URI.decode params[:content]
              end

    url = Shortener::ShortenedUrl.generate content

    render text: Rails.application.routes.url_helpers.url_for(
      controller: :"shortener/shortened_urls",
      action: :show,
      id: url.unique_key,
      only_path: false,
      host: ENV["SERVER_HOST"]
    )
  end

  def ip_information
    ip = request.remote_ip

    data = Util::IP.parse_ip(ip)

    render json: { data: data, message: "谢谢马云爸爸" }, scope: nil
  end

  def test
    Rails.logger.silence do
      render text: "ok"
    end
  end
end
