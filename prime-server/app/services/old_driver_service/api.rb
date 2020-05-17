# 向老司机接口发送请求
module OldDriverService
  class API
    attr_accessor :vin, :engine_num, :id_number, :license_no

    ResponseResult = Struct.new(:order_id, :status, :message) do
      def success?
        status == :success
      end
    end

    def initialize(vin: "", engine_num: "", id_number: "", license_no: "")
      @vin = vin
      @engine_num = engine_num
      @id_number = id_number
      @license_no = license_no
    end

    def buy_order
      response = RestClient.post(
        url,
        request_params
      )

      result = MultiJson.load(response)

      status = result.fetch("Success") ? :success : :failed
      ResponseResult.new(result.fetch("Data"), status, result.fetch("Message"))

      # {"Data"=>2174, "Version"=>"1.0.0", "Success"=>true, "Code"=>200, "Message"=>"OK"}
      # 这里的 Data 意思是生成报告的ID
      # 失败情况： order_id=0, status=:failed, message="Invalid vin"
    end

    private

    def request_params
      attrs = {
        Vin: @vin,
        EngineNumber: @engine_num,
        IDNumber: @id_number,
        CallbackUrl: callback_url,
        LicenseNo: @license_no,
        UserID: user_id,
        UserToken: user_token,
        TimeStamp: timestamp
      }

      sorted = sort_params(attrs)
      app_sign = sign("#{sorted}#{api_key}")

      unsort_params(attrs.merge(AppSign: app_sign))
    end

    def url
      "http://api.lsj001.com/a/OrderByVin"
    end

    def callback_url
      # TODO: 回调地址需要改
      case Rails.env
      when "production", "dashboard"
        "http://server.chelaike.com/api/v1/old_driver/notify".freeze
      else
        "http://prime.lina.che3bao.com:9292/api/v1/old_driver/notify".freeze
      end
    end

    def user_id
      # TODO: 这里还需要区分内部使用或给车商使用
      35
    end

    def user_token
      # TODO: 这里还需要区分内部使用或给车商使用
      ENV["OLD_DRIVER_USER_TOKEN"]
    end

    def api_key
      ENV["OLD_DRIVER_APP_KEY"]
    end

    def timestamp
      Time.zone.now.to_datetime.strftime("%Y%m%d%H%M%S%L")
    end

    def construct_params(attrs)
      arr = []
      attrs.each_pair do |key, value|
        arr << "#{key}=#{value}"
      end
      arr
    end

    def unsort_params(attrs)
      construct_params(attrs).join("&")
    end

    def sort_params(attrs)
      construct_params(attrs).sort.join("&")
    end

    def sign(attrs)
      Digest::MD5.hexdigest(attrs)
    end
  end
end
