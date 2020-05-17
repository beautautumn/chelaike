module CarPublisher
  class Che168Worker
    class Helper
      LOGIN_RETRY_LIMIT = 5

      def self.process_cookie(cookie)
        cookie.map { |k, v| "#{k}=#{v}" }.join("; ")
      end

      def self.find_brand(brand_name)
        brand = Megatron.find_brand_by_name(brand_name)

        return brand["data"] if brand
      end

      def self.find_series(series_name)
        series = Megatron.a_series(series_name)

        return series["data"] if series
      end

      def self.find_style(series_name, style_name)
        style = Megatron.style(series_name, style_name, "", "")

        return style["data"] if style
      end

      def self.car_name(name)
        URI.escape(URI.escape(name))
      end

      def self.color
        {
          "黑色" => "1",
          "白色" => "2",
          "红色" => "5",
          "黄色" => "8",
          "蓝色" => "6",
          "绿色" => "7",
          "紫色" => "10",
          "银灰色" => "3",
          "深灰色" => "4",
          "香槟色" => "9",
          "橙色" => "12",
          "棕色" => "13",
          "其他" => "11"
        }
      end

      def self.gear_box(gear)
        gear = "自动" if gear != "手动"

        V8::Context.new.eval("escape('#{gear}')")
      end

      def self.che168_region
        @che168_region ||= (RestClient.get "http://i.che168.com/js/AreaData.js").encode!(
          "UTF-8", "GB2312",
          undef: :replace, replace: "?", invalid: :replace
        )
      end

      def self.cities
        return @cities if @cities

        region = che168_region
        cities_json = V8::Context.new.eval("#{region}JSON.stringify(City_2sc);")

        @cities = Hash[JSON.parse(cities_json)["options"].map do |e|
          [(e["T"][2..-1]).to_s, e["V"]]
        end]
      end

      def self.provinces
        return @provinces if @provinces

        region = che168_region
        provinces_json = V8::Context.new.eval("#{region}JSON.stringify(Province_2sc);")

        @provinces = Hash[JSON.parse(provinces_json)["options"].map do |e|
          [(e["T"][2..-1]).to_s, e["V"]]
        end]
      end

      def self.car_configuration(cookie, style_id)
        host = "http://dealer.che168.com/Handler/CarManager/SalesCarPart.ashx"
        url = "#{host}?cd=gca&spid=#{style_id}"

        response = JSON.parse(RestClient.get(url, cookies: cookie))

        {
          car_options: response["CarOption"] || "",
          displacement: response["displa"],
          fuel_type: response["fueltype"]
        }
      end

      def self.upload_images(cookie, urls)
        urls.map do |url|
          upload_image(cookie, url)
        end.compact.join(",")
      end

      def self.upload_image(cookie, url)
        response = RestClient::Request.execute(
          method: :post,
          url: "http://upload.che168.com/UploadImage.ashx?infoid=1000",
          payload: open(url),
          headers: {
            content_type: "application/octet-stream",
            cookies: cookie
          }
        )

        JSON.parse(response)["msg"]
      rescue
        nil
      end

      def self.sellers(cookie)
        normal_dealer = "dealers"
        vip_dealer = "dealer"

        data = fetch_sellers(cookie, normal_dealer)
        data = fetch_sellers(cookie, vip_dealer) if data.blank?

        data
      end

      def self.fetch_sellers(cookie, dealer)
        response = RestClient.get "http://#{dealer}.che168.com/car/publish/", cookies: cookie
        response.encode!(
          "UTF-8", "GB2312",
          undef: :replace, replace: "?", invalid: :replace
        )

        doc = Nokogiri::HTML.parse response

        doc.css("#sh_linkMan_div > a").map do |row|
          {
            name: row.text,
            id: row.attr("rel")
          }
        end
      end

      def self.valid_model?(model)
        model && !model["code"].to_s.empty? && !model["code"].to_s.start_with?("2015")
      end

      def self.sync_che168_state(che168_id, car, cookie)
        style = find_style(car.series_name, car.style_name)

        return unless valid_model?(style)

        %w(published reviewing failed).each_with_index do |state, index|
          che168_state(
            cookie,
            "/car/carlist/?s=#{index + 1}&specid=#{style["code"]}",
            state,
            che168_id
          )
        end
      end

      def self.login?(cookies)
        url = "http://dealer.che168.com/Handler/CarManager/SalesCarPart.ashx"

        response = RestClient.get url, cookies: cookies

        response.body == ""
      end

      def self.login(profile)
        @profile = profile.data
        @profile["cookies"] ||= {}
        code_info = login_code

        username = URI.escape(@profile["username"].encode("GB2312", "UTF-8"))
        password = V8::Context.new.eval("escape('#{@profile["password"]}');")
        code = V8::Context.new.eval("escape('#{code_info[:value]}');")
        random = V8::Context.new.eval("Math.random();")

        url = <<-URL.strip_heredoc.delete("\n")
          http://dealer.che168.com/Handler/Login/Login.ashx?
          name=#{username}&pwd=#{password}&validcode=#{code}&remember=false&req=#{random}
        URL

        RestClient.proxy = Util::Request.proxy_url
        response = RestClient.get(
          url,
          Referer: "http://dealer.che168.com/login.html?backurl=/car/carlist/?s=3",
          "User-Agent" => user_agent,
          cookies: @profile["cookies"].merge(code_info[:cookies])
        )

        @login_retry ||= 0

        login_handler(profile, response)
      ensure
        RestClient.proxy = ""
      end

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def self.login_handler(profile, response)
        if response.cookies["2scDealerId"]
          @login_retry = 0
          @profile["cookies"] = response.cookies.slice(
            "2scDealerInfo", "2scDealerName", "2scDealerId"
          )

          profile.data["cookies"] = @profile["cookies"]
          profile.save!

          response.cookies
        else
          message = V8::Context.new.eval("#{response.body.encode!("UTF-8", "GB2312")};code;")

          case
          when message.include?("验证码") && @login_retry >= LOGIN_RETRY_LIMIT
            raise Error::LoginRetryLimit, @record
          when message.include?("验证码") && @login_retry < LOGIN_RETRY_LIMIT
            @login_retry += 1
            login(profile)
          when message.include?("密码")
            @login_retry = 0
            raise Error::InvalidLoginInfo, @record
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      def self.login_code
        code("http://dealer.che168.com/Handler/CreateImgCode.ashx")
      end

      def self.code(url)
        filename = SecureRandom.hex.to_s
        tmp_code_path = "#{Rails.root}/tmp/#{filename}.gif"
        output_path = "#{Rails.root}/tmp/#{filename}"

        response = RestClient.get url

        File.open(tmp_code_path, "wb") { |file| file.write(response.body) }

        code = `python #{Rails.root}/bin/recognize_code.py #{tmp_code_path} #{output_path}`

        File.unlink(tmp_code_path)

        {
          value: code,
          cookies: response.cookies
        }
      end

      def self.fetch_state(host, cookie, state, che168_id)
        doc = fetch(host, cookie)
        found = false

        loop do
          doc.css(".content_ul > li").each do |item|
            found_che168_id = item.attr("id")[2..-1].to_i

            next unless che168_id == found_che168_id
            found = true
            record = Che168PublishRecord.find_by(che168_id: che168_id)
            message = item.css(".appealcontent").try(:text)

            record.update(publish_state: state, publish_message: message) if record

            break
          end

          next_page = doc.at_css(".page-item-next") ? doc.css(".page-item-next").attr("href") : nil
          break if found || next_page.blank?

          doc = fetch(host + next_page, cookie)
        end
      end

      def self.che168_state(cookie, url, state, che168_id)
        vip_host = "http://dealer.che168.com"
        host = "http://dealers.che168.com"

        fetch_state(vip_host + url, cookie, state, che168_id)
        fetch_state(host + url, cookie, state, che168_id)
      end

      def self.fetch(url, cookie)
        response = RestClient.get url, cookies: cookie
        response.encode!(
          "UTF-8", "GB2312",
          undef: :replace, replace: "?", invalid: :replace
        )

        Nokogiri::HTML.parse response
      end

      def self.user_agent
        <<-AGENT.squish
          User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1)
          AppleWebKit/537.36 (KHTML, like Gecko)
          Chrome/47.0.2526.106 Safari/537.36
        AGENT
      end
    end
  end
end
