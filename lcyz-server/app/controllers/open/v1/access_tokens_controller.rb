module Open
  module V1
    class AccessTokensController < Open::ApplicationController
      skip_before_action :authenticate_app!, except: :ping

      def create
        company = Company.find(params[:app_id])

        begin
          data = JWT.decode params[:signature],
                            company.app_secret, true, algorithm: "HS256"

          if data[0]["app_secret"] == company.app_secret
            response_data = {
              data: {
                access_token: company.token,
                expired_time: 1.day.to_i
              }
            }

            render json: response_data, scope: nil
          else
            unauthorized_error("非法的App secret")
          end

        rescue JWT::VerificationError
          unauthorized_error("签名解密失败或格式错误")
        end
      end

      def ping
        render text: "pong"
      end
    end
  end
end
