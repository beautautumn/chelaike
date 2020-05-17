module Dashenglaile
  class Record
    extend Dashenglaile::Request

    def self.query(brand_id: nil, vin:, order_id:, engine_num: nil, _is_vin: nil)
      result = dasheng_post(
        sign: true,
        interface: "create_query_policy_by_partner",
        _input_charset: "UTF-8",
        notify_url: call_back_url,
        vin: vin,
        brand_id: brand_id,
        order_id: order_id,
        engine_number: engine_num
      )
      # 测试环境需要手动调用 test_report
      if Rails.env.staging? || Rails.env.test?
        test_report(order_id: order_id, is_text: 1)
      end

      result
    end

    # is_text 1 代表文字版，0 代表图片版。部分品牌不支持文字版(is_automation 字段)
    def self.test_report(order_id:, is_text:)
      dasheng_get(
        "http://test.dashenglaile.com/autoResponse/v2/?service=maintenance"\
        "&partner=#{ENV["DASHENG_ID"]}" \
        "&order_id=#{order_id}" \
        "&status=1&content=#{is_text}"
      )
    end

    def self.report(order_id:)
      dasheng_post(
        sign: true,
        interface: "get_query_response",
        order_id: order_id,
        created: DateTime.current.to_s(:db)
      )
    end
  end
end
