module ChaDoctorService
  class API
    CALLBACK_URL = case Rails.env
                   when "production", "dashboard"
                     "http://server.chelaike.com/api/v1/cha_doctor/notify".freeze
                   when "staging"
                     "http://prime.lina.che3bao.com:9292/api/v1/cha_doctor/notify".freeze
                   end

    class << self
      def check_brand(vin)
        api = "/report/check_brand"

        attrs = { vin: vin }
        resp = ChaDoctorService::Util.get_request(api, attrs)

        resp_code = resp.fetch("Code").to_s
        resp_message = resp.fetch("Message")

        external_error_codes = %w(1101 11011 11012 11013 1107 11071 1201)

        result = ReturnResult.new(code: resp_code, message: resp_message)

        case
        when resp_code == "1106"
          return result.success
        # 没到上班时间/不支持此品牌
        when resp_code == "1100"
          result = ReturnResult.new(code: resp_code, message: "此时暂不支持查询")
          return result.external_error
        when resp_code.in?(external_error_codes)
          return result.external_error
        else
          return result.internal_error
        end
      end

      def buy_report(vin, licenseplate = "")
        api = "/report/buy_report"
        attrs = { vin: vin, callbackurl: CALLBACK_URL, licenseplate: licenseplate }
        resp = ChaDoctorService::Util.post_request(api, attrs)

        code = resp.fetch("Code").to_s
        message = resp.fetch("Message")

        external_error_codes = %w(1101 11011 11012
                                  11013 1107 11071 1201 12011
                                  1202 12021 1203 12031)

        result = ReturnResult.new(code: code, message: message)

        case
        when code == "0"
          order_id = resp.fetch("orderId")
          return result.success(order_id)
        # 没到上班时间/不支持此品牌
        when code == "1100"
          result = ReturnResult.new(code: code, message: "此时暂不支持查询")
          return result.external_error
        when code.in?(external_error_codes)
          return result.external_error
        else
          return result.internal_error
        end
      end

      def get_report_json(order_id)
        api = "/new_report/get_report"
        attrs = { orderid: order_id }

        resp = ChaDoctorService::Util.get_request(api, attrs)

        code = resp.fetch("Code").to_s
        message = resp.fetch("Message")

        external_error_codes = %w(1101 11011 11012 11013 1102
                                  1105 11051 11052 11053 1107
                                  11071 1200)

        result = ReturnResult.new(code: code, message: message)

        case
        when code == "1104"
          data = resp.except!("Code", "Message")
          return result.success(data)
        when code.in?(external_error_codes)
          return result.external_error
        else
          return result.internal_error
        end
      end

      def parse_summary_data(url)
        total_hash = {}
        doc = Nokogiri::HTML(open(url))
        total_hash = total_hash.merge(parse_accident_status(doc))
                               .merge(parse_main_parts(doc))
                               .merge(parse_cover_parts(doc))
        return_data = { summany_status_data: total_hash }
        ReturnResult.new.success(return_data)
      end

      private

      # 解析事故分析(车身结构维修记录)
      def parse_accident_status(doc)
        { accident_status_data: parse_detail_parts(doc, "#tab > div.cf > ul.list") }
      end

      # 重要组成部件维修记录
      def parse_main_parts(doc)
        { main_parts_data: parse_detail_parts(doc, "#tab1 > div.energer_img.cf > div > ul") }
      end

      # 车身覆盖件维修记录
      def parse_cover_parts(doc)
        { cover_parts_data: parse_detail_parts(doc, "#tab1 > div:nth-child(7) > ul.list") }
      end

      def parse_detail_parts(doc, selector)
        parts_data = []

        lists = doc.css(selector)
        lists.each do |list|
          items = list.css("li")
          items.each do |item|
            attr_name = item.text.squish
            flag = item.css("i").first
            attr_value = flag.attributes["class"].try(:value) == "err"

            parts_data << { key: attr_name, value: !attr_value }
          end
        end

        parts_data
      end
    end # end of class methods

    class ReturnResult
      attr_accessor :status, :code, :message, :data

      def initialize(status: nil, code: nil, message: nil, data: nil)
        @status = status
        @code = code
        @message = message
        @data = data
      end

      def success(data = nil)
        @status = :success
        @data = data
        self
      end

      # 要显示给用户看到的错误
      def external_error(data = nil)
        @status = :external_error
        @data = data
        self
      end

      # 统一包装后显示给用户，并发送邮件给开发者
      def internal_error(data = nil)
        @status = :internal_error
        @data = data
        self
      end
    end
  end
end
