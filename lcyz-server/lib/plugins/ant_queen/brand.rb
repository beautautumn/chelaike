module AntQueen
  class Brand
    extend AntQueen::Request
    BRAND_CACHE_KEY = "ant_queen:brand".freeze
    # 0:图片模式
    # 1:文字模式

    Special = %w(兰博基尼 纳智捷 东南三菱 林肯 长城 广汽三菱 宾利 哈弗 东南汽车 奔腾 比亚迪 奇瑞
                 红旗 吉利 开瑞 日产(东风) 长安铃木 凯翼 昌河铃木 江淮 长安轿车 DS 英伦 长安商用
                 北汽幻速 北京汽车 东风风行).freeze

    def self.get(is_text: nil, company: nil)
      path = "/OpenApi/getBrandInfo".freeze
      Rails.cache.fetch(cache_key(company), expires_in: 10.minutes) do
        params = { token: AntQueen::Token.get }
        # 支持两种模式的所有，难道要分别传参数请求两次？
        params[:is_text] = is_text
        result = ant_post(path: path, params: params)
        result["list"].each do |b|
          b["first_letter"] = b["pingyin_name"][0].upcase
          b["hint"] = if b["status"] == "0"
                        nil
                      else
                        b["hint"].presence
                      end
          b["time_hint"] = time_hint(brand_name: b["name"])
          change_price(b, company)
        end
      end
    end

    def self.cache_key(company)
      if company && company.active_tag
        "ant_queen:brand:#{company.id}"
      else
        BRAND_CACHE_KEY
      end
    end

    def self.change_price(h, company)
      price = "29".freeze
      h["query_price"] = if company && company.active_tag && h["query_price"] == price
                           MaintenanceSetting.instance.ant_queen_unit_price.to_i
                         else
                           h["query_price"].to_i
                         end
    end

    def self.time_hint(brand_name:)
      now = Time.zone.now
      start_time, end_time = if Special.include?(brand_name)
                               [{ hour: 9, min: 0 }, { hour: 18, min: 0 }].freeze
                             else
                               [{ hour: 9, min: 0 }, { hour: 20, min: 0 }].freeze
                             end
      start_at =  now.change(hour: start_time[:hour], min: start_time[:min])
      end_at = now.change(hour: end_time[:hour], min: end_time[:min])
      if now < start_at
        "工作时间9:00-#{end_time[:hour]}:00，本次查询将在今天9:00上班后处理"
      elsif now > end_at
        "工作时间9:00-#{end_time[:hour]}:00，本次查询将在次日9:00上班后处理"
      end
    end

    def self.working_hours(brand_id:)
      brand = get.find { |b| b["id"].to_i == brand_id }

      if Special.include?(brand.try("[]", "name"))
        [{ hour: 9, min: 0 }, { hour: 18, min: 0 }].freeze
      else
        [{ hour: 9, min: 0 }, { hour: 20, min: 0 }].freeze
      end
    end
  end
end
