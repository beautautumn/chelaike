# rubocop:disable Rails/Output,Metrics/AbcSize
module Spy
  module V2
    class Prices
      def initialize
        @series_code = 0
        @city_id = 0
        @style_ids = []
        @price_data
      end

      def crawl
        puts "==> Fecth all prices.".red
        prices
        puts "==> Mission completed.".red

        "Your Garce."
      end

      def cities
        return @cities unless @cities.nil?

        doc = fetch("http://www.autohome.com.cn/hangzhou/")
        regions = json_parse(doc.css("script")[2].text)

        @cities = regions.map do |region|
          {
            id: region[2],
            name: region[3],
            province: region[6]
          }
        end
      end

      def storage
        @price_data.each do |id, data|
          price = StylePrice.find_or_initialize_by(
            series_code: @series_code, code: id
          )

          price.data = data
          price.series_code = @series_code
          price.code = id

          price.save
        end

        puts "==> Storage Finished.".green

        self
      end

      def price
        return if @series_code == 2608
        @price_data = {}
        puts "==> Get price of series:: #{@series_code}".blue

        @city_id = "110100"
        response = RestClient.get url
        response.encode!(
          "UTF-8", "GB2312",
          undef: :replace, replace: "?", invalid: :replace)

        return if JSON.parse(response)["result"]["list"].size <= 0

        cities.each do |city|
          @city_id = city[:id]

          begin
            response = RestClient.get url
            response.encode!(
              "UTF-8", "GB2312",
              undef: :replace, replace: "?", invalid: :replace)
          rescue
            next
          end

          JSON.parse(response)["result"]["list"].each do |style|
            @price_data["#{style["SpecId"]}"] =
              @price_data["#{style["SpecId"]}"] || {}
            @price_data["#{style["SpecId"]}"]["#{city[:province]} #{city[:name]}"] =
              { minimum_price: style["MinPrice"] }

            puts "fetch price from region: #{city[:province]} #{city[:name]}".blue
            puts "\t*** Style:: #{style["SpecId"]}  price:: #{style["MinPrice"]}"
              .yellow
          end
        end

        storage if @price_data != {}
      end

      def prices
        total = 100
        skip = 0
        order = 1
        limit = 100

        14.times do
          ::Style.all.order(series_code: :asc).skip(skip).limit(limit)
            .no_timeout.each_with_index do |style, index|
            next unless style.styles.length > 0

            puts "%NO#{order}  [#{index + 1}/#{total}]"
            @series_code = style[:series_code]

            @style_ids = []
            style.styles.each do |s|
              s[:models].each do |model|
                @style_ids << model[:id]
              end
            end

            price
          end

          skip += limit
          order += 1
        end

        self
      end

      def json_parse(text)
        begin
          V8::Context.new.eval("#{text}CityArr;").to_a
        rescue
          []
        end
      end

      def url
        "http://www.autohome.com.cn/ashx/series_dealerprice.ashx?"\
        "c=#{@city_id}&s=#{@style_ids.join(",")}&seriesId=#{@series_code}"
      end

      def fetch(url)
        puts "==> Fetch #{url}".green

        response = RestClient.get url
        response.encode!(
          "UTF-8", "GB2312",
          undef: :replace, replace: "?", invalid: :replace)
        Nokogiri::HTML.parse response
      end
    end
  end
end
# rubocop:enable Rails/Output,Metrics/AbcSize
