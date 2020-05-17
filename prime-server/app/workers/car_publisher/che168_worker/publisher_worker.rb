module CarPublisher
  class Che168Worker
    class PublisherWorker
      attr_reader :record

      LOGIN_RETRY_LIMIT = 5
      UPDATE_RETRY_LIMIT = 5

      def initialize(company_id, record_id)
        @company = Company.find(company_id)
        @record = Che168PublishRecord.find(record_id)
        @profile = @company.che168_profile.try(:data) || {}
        @login_retry = 0
        @update_retry = 0
      end

      def car_code
        code("http://dealer.che168.com/Handler/ActionSale/CreateImgCode.ashx")
      end

      def sold
        car = @record.car
        # 目前控制在che168只下架，不提供已售信息。所以设置price为空
        # 如果需要设置为已售状态，则获取出库的成交价格
        # price = car.try(:stock_out_inventory).try(:closing_cost_wan) || ""
        price = ""
        customer_name = car.try(:stock_out_inventory).try(:customer_name) || ""
        type = price.blank? ? "overtime" : "setselled"

        url = <<-URL.strip_heredoc.delete("\n")
          http://dealer.che168.com/Handler/CarManager/CarOperate.ashx?
          dealerid=#{@profile["cookies"]["2scDealerId"]}
          &action=#{type}
          &status=1
          &infoid=#{@record.che168_id}
          &price=#{price}
          &buyname=#{V8::Context.new.eval("escape('#{customer_name}');")}
          &buyMobile=#{car.try(:stock_out_inventory).try(:customer_phone)}
          &sourcePic=undefined
          &vinPic=undefined
          &vinCode=undefined
        URL

        response = RestClient.get url,
                                  cookies: @profile["cookies"],
                                  Referer: "http://dealer.che168.com/car/carlist/?s=1"

        @record.update!(publish_state: "sold") if response.body == "1"
      end

      def update
        Helper.login(@company.che168_profile) unless Helper.login?(@profile["cookies"])

        car = @record.car
        code_info = car_code
        seller = Helper.sellers(@profile["cookies"]).detect do |e|
          e[:id] == @record.seller_id
        end

        code = code_info[:value]
        data = prepare_data(car, seller, @record.che168_id, code)

        command = <<-BASH.squish
          curl -s
            'http://dealer.che168.com/Handler/CarManager/SaleCar.ashx'
            -H 'Pragma: no-cache'
            -H 'Origin: http://dealer.che168.com'
            -H 'Accept-Encoding: gzip, deflate'
            -H 'Accept-Language: zh-CN,zh;q=0.8,en;q=0.6'
            -H '#{user_agent}'
            -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'
            -H 'Accept: text/plain, */*; q=0.01'
            -H 'Cache-Control: no-cache'
            -H 'X-Requested-With: XMLHttpRequest'
            -H 'Cookie: #{Helper.process_cookie(@profile["cookies"].merge(code_info[:cookies]))}'
            -H 'Connection: keep-alive'
            -H 'Referer: http://dealer.che168.com/car/publish/?s=1'
            --data '#{data}'
            --compressed
        BASH

        updation_handler(`#{command}`, car, seller, command)
      end

      def create
        Helper.login(@company.che168_profile) unless Helper.login?(@profile["cookies"])

        car = @record.car
        seller = Helper.sellers(@profile["cookies"]).detect do |e|
          e[:id] == @record.seller_id
        end

        data = prepare_data(car, seller)

        command = <<-BASH.squish
          curl -s
            'http://dealer.che168.com/Handler/CarManager/SaleCar.ashx'
            -H 'Pragma: no-cache'
            -H 'Origin: http://dealer.che168.com'
            -H 'Accept-Encoding: gzip, deflate'
            -H 'Accept-Language: zh-CN,zh;q=0.8,en;q=0.6'
            -H '#{user_agent}'
            -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'
            -H 'Accept: text/plain, */*; q=0.01'
            -H 'Cache-Control: no-cache'
            -H 'X-Requested-With: XMLHttpRequest'
            -H 'Cookie: #{Helper.process_cookie(@profile["cookies"])}'
            -H 'Connection: keep-alive'
            -H 'Referer: http://dealer.che168.com/car/publish/?s=1'
            --data '#{data}'
            --compressed
        BASH

        creation_handler(`#{command}`, command)
      end

      private

      def updation_handler(response, car, seller, command)
        status, id = response.split("|")

        if status == "-1"
          raise(Error::UpdateRetryLimit, @record) if @update_retry >= UPDATE_RETRY_LIMIT

          @update_retry += 1
          return update(car, seller)
        end

        @update_retry = 0

        raise(Error::InternalError, @record) if id == "502"

        @record.update!(che168_id: id.to_i, state: "finished", command: command)
      end

      def creation_handler(response, command)
        _status, id = response.split("|")

        raise(Error::InternalError, @record) if id == "502"

        @record.update!(
          che168_id: id.to_i, state: "finished",
          publish_state: "reviewing", command: command
        )
      end

      def user_agent
        <<-AGENT.squish
          User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1)
          AppleWebKit/537.36 (KHTML, like Gecko)
          Chrome/47.0.2526.106 Safari/537.36
        AGENT
      end

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength
      def check_data(data, model, region, configuration)
        brand = model[:brand]
        series = model[:series]
        style = model[:style]
        province_id = region[:province_id]
        city_id = region[:city_id]

        case
        when data[:price].blank? || data[:price] == 0
          raise Error::InvalidPrice, @record
        when data[:mileage].blank?
          raise Error::InvalidMileage, @record
        when data[:licensed_at].blank?
          raise Error::InvalidLicensedAt, @record
        when data[:images].size <= 0
          raise Error::EmptyImages, @record
        when !Helper.valid_model?(brand)
          raise Error::InvalidBrand, @record
        when !Helper.valid_model?(series)
          raise Error::InvalidSeries, @record
        when !Helper.valid_model?(style)
          raise Error::InvalidStyle, @record
        when province_id.blank?
          raise Error::InvalidProvince, @record
        when city_id.blank?
          raise Error::InvalidCity, @record
        when configuration[:displacement].blank?
          raise Error::InvalidConfiguration, @record
        end
      end

      def wrap_data(data, model, region, configuration)
        brand = model[:brand]
        series = model[:series]
        style = model[:style]
        province_id = region[:province_id]
        city_id = region[:city_id]

        data = {
          infoid: data[:info_id],
          brandid: brand["code"],
          seriesid: series["code"],
          specid: style["code"],
          carname: Helper.car_name(data[:car_name]),
          options: configuration[:car_options],
          displa: configuration[:displacement],
          fueltype: configuration[:fuel_type],
          gearbos: Helper.gear_box(data[:gear]),
          iscontainfee: "0",
          price: data[:price],
          mileage: data[:mileage],
          pid: province_id,
          cid: city_id,
          registedate: data[:licensed_at].strftime("%Y-%m"),
          Examine: data[:annual_inspection_end_at].strftime("%Y-%m"),
          Insurance: data[:compulsory_insurance_end_at].strftime("%Y-%m"),
          Taxtime: data[:compulsory_insurance_end_at].strftime("%Y"),
          TransferTimes: data[:transfer_count],
          CarUse: "1",
          colorcode: Helper.color[data[:exterior_color]] || "11",
          linkman: V8::Context.new.eval("escape('#{data[:seller][:name]}')"),
          linkmanid: data[:seller][:id],
          CertificateType: "0",
          isvalidvincode: "0",
          xs_certify: "",
          fromType: "0",
          isFreeCheckCar: "0",
          validcode: data[:code],
          pictures: Helper.upload_images(@profile["cookies"], data[:images]),
          remark: data[:selling_point]
        }

        data.map do |k, v|
          "#{k}=#{v}"
        end.join("&")
      end

      def prepare_data(car, seller, che168_id = nil, code = nil)
        transfer = car.acquisition_transfer
        annual_inspection_end_at =
          transfer.try(:annual_inspection_end_at) || car.licensed_at + 2.years
        compulsory_insurance_end_at =
          transfer.try(:compulsory_insurance_end_at) || car.licensed_at + 2.years

        data = {
          info_id: che168_id || "0",
          code: code || "undefined",
          car_name: [car.brand_name, car.series_name, car.style_name].join(" "),
          brand_name: car.brand_name,
          series_name: car.series_name,
          style_name: car.style_name,
          gear: (car.transmission_text || "自动")[0...2],
          price: car.online_price_wan || car.show_price_wan,
          mileage: car.mileage,
          province: @company.province,
          city: @company.city,
          licensed_at: car.licensed_at,
          annual_inspection_end_at: annual_inspection_end_at,
          compulsory_insurance_end_at: compulsory_insurance_end_at,
          transfer_count: car.acquisition_transfer.try(:transfer_count) || 0,
          exterior_color: car.exterior_color || "其他",
          seller: seller,
          selling_point: car.selling_point || "",
          images: (car.images || []).map(&:url)
        }

        style = Helper.find_style(data[:series_name], data[:style_name])

        model = {
          brand: Helper.find_brand(data[:brand_name]),
          series: Helper.find_series(data[:series_name]),
          style: style
        }
        region = {
          province_id: Helper.provinces.detect { |p, _id| data[:province].include?(p) }
                             .try(:second),
          city_id: Helper.cities.detect { |c, _id| data[:city].include?(c) }
                         .try(:second)
        }

        configuration = Helper.car_configuration(@profile["cookies"], style["code"])

        check_data(data, model, region, configuration)
        wrap_data(data, model, region, configuration)
      end
      # rubocop:enable Metrics/PerceivedComplexity, Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

      def code(url)
        filename = SecureRandom.hex.to_s
        tmp_code_path = "#{Rails.root}/tmp/#{filename}.gif"
        output_path = "#{Rails.root}/tmp/#{filename}"
        random = V8::Context.new.eval("Math.random();")

        response = RestClient.get "#{url}?#{random}"

        File.open(tmp_code_path, "wb") { |file| file.write(response.body) }

        code = `python #{Rails.root}/bin/recognize_code.py #{tmp_code_path} #{output_path}`

        File.unlink(tmp_code_path)

        {
          value: code,
          cookies: response.cookies
        }
      end
    end
  end
end
