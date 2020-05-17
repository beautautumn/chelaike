# frozen_string_literal: true
module Wechat
  class Reducer
    module Scene
      include Wechat::Reply
      # 价签二维码
      def price_tag_scan(message, _app_id, data)
        # wechat_app = WechatApp.find_by(app_id: app_id)
        car = find_car(data)
        link_url = Car::WeshopService.new(car).car_detail_url

        article = generate_article(
          title: car.name,
          desc: car_description(car),
          pic_url: car_cover(car),
          link_url: link_url
        )
        reply_articles_message(
          from: message["ToUserName"],
          to: message["FromUserName"],
          articles: article
        )
      end

      def scan_scene(type, id)
        return unless [
          Wechat::Reducer::PRICE_TAG_SCAN,
          Wechat::Reducer::CHANNEL_SCAN
        ].member? type
        {
          type: type,
          data: {
            id: id
          }
        }.to_json
      end

      private

      def find_car(data)
        Car.find(data["data"]["id"].to_i)
      end

      def find_channel(data)
        Channel.find(data["data"]["id"].to_i)
      end

      def car_description(car)
        <<-DESCRIPTION.squish
          #{car.licensed_at.try(:strftime, "%Y年%m月")}上牌,
          #{car.mileage} 万公里,
          #{car.exterior_color},
          排量#{car.displacement_text},
          标价#{car.show_price_wan}万元。
        DESCRIPTION
      end

      def car_cover(car)
        car.cover.try(:url) ||
          car.images.first.try(:url) ||
          "http://tianche-weixin.oss-cn-hangzhou.aliyuncs.com/default_car_cover.png"
      end
    end
  end
end
