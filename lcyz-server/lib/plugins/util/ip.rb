module Util
  class IP
    class << self
      def parse_ip(ip)
        cache_key = Digest::MD5.hexdigest("ip_information:#{ip}")

        Rails.cache.fetch(cache_key) do
          url = "http://ip.taobao.com/service/getIpInfo.php?ip=#{ip}"

          JSON.parse(Util::Request.get(url, open_timeout: 5)).fetch("data")
        end
      end
    end
  end
end
