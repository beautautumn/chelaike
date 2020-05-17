module Util
  class WaterMark
    def self.make_for(url, water_mark_position, water_mark_url)
      return url if water_mark_position.blank? || water_mark_url.blank?
      key = water_mark_url.match(%r{.*.com\/(.*)})[1]

      encoded_object = UrlSafeBase64.encode64("#{key}@30P")

      "#{url}@watermark=1&object=#{encoded_object}&#{water_mark_position.to_query}"
    end
  end
end
