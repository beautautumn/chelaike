module Util
  class QRCode
    class << self
      def youhaosuda_url(company_id, car_id)
        result = JSON.parse(
          Util::Request.get("http://chelaike.ibanquan.com/api/queryURL?cid=#{company_id}")
        )

        status = result.fetch("status").to_i
        url = result.fetch("url")

        status == 1 ? "#{url}/pages/products#id=#{car_id}" : "#{url}product/#{car_id}"
      end

      # 新官网
      def new_official_url(car_id)
        car = Car.find(car_id)
        Car::WeshopService.new(car).car_detail_url
      end
    end
  end
end
