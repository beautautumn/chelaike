module Dashenglaile
  module Request
    include Dashenglaile::Error

    def dasheng_post(sign: false, interface:, **params) # **: hash after optional params
      # 确保服务可用
      # raise Dashenglaile::Error::Request unless ping?

      request_params = params.merge(partner: ENV["DASHENG_ID"], interface: interface)
                             .compact
      if sign
        request_params[:sign] = sign(request_params)
        request_params[:sign_type] = "MD5"
      end

      request_host = interface == "create_query_policy_by_partner" ? host : host_v3
      response = RestClient::Request.execute(
        method: :post,
        url: request_host,
        payload: request_params,
        timeout: 5
      )
      error(parse_result(response))
    end

    def dasheng_get(url)
      # 确保服务可用
      # raise Dashenglaile::Error::Request unless ping?
      respsone = RestClient.get(url)
      parse_result(respsone)
    end

    def call_back_url
      case Rails.env
      when "staging"
        "http://prime.lina.che3bao.com/api/v1/dashenglaile/notify".freeze
      else
        # ["production", "development", "test", "dashboard"]
        "http://server.chelaike.com/api/v1/dashenglaile/notify".freeze
      end
    end

    private

    def parse_result(response)
      JSON.parse(response)
    rescue JSON::ParserError
      # 推送维保报告, "传递参数"开头, PHP Array 格式
      if response.start_with?("传递参数")
        result = response.match %r{<pre>Array\s*\(\s*(\[.*)\s*\)\s*<\/pre><br><br>待签名字符串}m
        array_to_hash(result.captures[0])
      # HTML 维保报告
      elsif response.start_with?("<")
        response
      else # 创建维保查询订单, PHP Array + JSON
        result = response.match(/\{.*\}/)
        JSON.parse(result[0])
      end
    end

    def array_to_hash(php_array)
      result = {}
      php_array.each_line do |line|
        k, v = line.strip!.match(/\[(.*)\] => (.*)/).captures
        result[k] = v
      end
      result
    end

    def ping?
      response = RestClient.get host
      return true if response.code == 200
      false
    end

    def host_v3
      ENV.fetch("DASHENG_V3_URL")
    end

    def host
      ENV.fetch("DASHENG_V2_URL")
    end

    def sign(payload)
      sorted_params = Hash[payload.sort_by { |k, _| k }]
      to_be_signed = sorted_params.map { |k, v| "#{k}=#{v}" }.join("&") + ENV["DASHENG_KEY"]
      Digest::MD5.hexdigest(to_be_signed)
    end
  end
end
