module V1
  module AllianceDashboard
    class OssConfigurationsController < V1::AllianceDashboard::ApplicationController
      before_action :skip_authorization

      def create
        aliyun_oss = AliyunOss.new.sign!

        hash = {
          data: {
            policy: aliyun_oss.oss_policy,
            signature: aliyun_oss.signature,
            oss_key: ENV.fetch("ACCESS_KEY_ID")
          }
        }

        render json: hash, scope: nil
      end
    end
  end
end
