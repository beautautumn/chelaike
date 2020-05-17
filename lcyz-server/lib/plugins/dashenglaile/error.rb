module Dashenglaile
  module Error
    Token = Class.new(StandardError)
    Request = Class.new(StandardError)
    Buy = Class.new(StandardError)
    Vin = Class.new(StandardError)
    Vendor = Class.new(StandardError)
    # rubocop:disable Metrics/CyclomaticComplexity
    def error(result)
      # HTML 报告
      return result unless result.is_a? Hash
      case result["error_code"]
      when 0
        return result["response"].present? ? result["response"] : true
      when -1      # 系统繁忙
        raise Dashenglaile::Error::Request, "系统繁忙, 请稍后再试"
      when [40001, # 参数不完整
            40002, # 不合法的接口名称
            40003, # 不合法的合作伙伴 ID
            40004, # 不合法的签名
            40005, # 不合法的参数编码字符串
            40006, # 不合法的签名方式
            40007, # 不合法的通知地址
            40010, # 不合法的车辆品牌 ID
            60001] # 不合法的异步请求
        raise Dashenglaile::Error::Request, "请求参数有误"
      when 40008   # 不合法的车架号
        raise Dashenglaile::Error::Vin, "车架号有误"
      when 40009   # 不合法的订单号
        raise Dashenglaile::Error::Buy, "订单号有误"
      when 40011   # 请求时间过期
        raise Dashenglaile::Error::Request, "请求时间过期"
      when 40012   # 订单不存在
        raise Dashenglaile::Error::Buy, "订单不存在"
      when 40013   # v3: 订单正在查询中/ v2: 未能通过车架号识别品牌
        raise Dashenglaile::Error::Vin, "未能通过车架号识别品牌"
        # raise Dashenglaile::Error::Buy, "订单正在查询中, 请稍后再试"
        # when 40014   # 未能通过车架号识别品牌
        # raise Dashenglaile::Error::Vin, "未能通过车架号识别品牌"
      when 50001 # 余额不足
        raise Dashenglaile::Error::Token, "余额不足"
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
