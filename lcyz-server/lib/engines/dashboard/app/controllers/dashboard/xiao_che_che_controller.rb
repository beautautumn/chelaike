module Dashboard
  class XiaoCheCheController < ApplicationController
    before_action do
      authorize :dashboard_xiao_che_che
    end

    def new; end

    def publish
      processing do
        ::XiaoCheCheService.execute(params[:message_text], params[:ids_text])
      end

      redirect_to new_xiao_che_che_path, notice: "成功"
    end

    private

    def processing
      if Rails.env.dashboard? || Rails.env.production?
        ex_time = 30 * 60
        RedisClient.current.setex(mutex_key, ex_time, "1")
      end

      yield
    end

    def mutex_key
      "xiao_che_che_send_message"
    end
  end
end
