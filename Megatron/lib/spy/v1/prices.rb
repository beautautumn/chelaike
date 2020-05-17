# rubocop:disable Rails/Output,Metrics/AbcSize
module Spy
  class Prices
    def self.import
      puts "==> Import Prices\n".light_blue

      prices

      puts "\n==> Mession Completed".light_red
    end

    def self.cities
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

    def self.price(series_id, style_ids)
      price_data = {}
      puts "==> Get price of series:: #{series_id}".blue

      url = "http://www.autohome.com.cn/ashx/series_dealerprice.ashx?"
      cities.each do |city|
        response = RestClient.get "#{url}c=#{city[:id]}&s=#{style_ids.join(",")}"
        response.force_encoding("GB2312")
        response.encode!("UTF-8")

        JSON.parse(response)["result"]["list"].each do |style|
          price_data["#{style["SpecId"]}"] = price_data["#{style["SpecId"]}"] || {}
          price_data["#{style["SpecId"]}"]["#{city[:province]} #{city[:name]}"] =
            { min_price: style["MinPrice"] }

          puts "\t*** Style:: #{style["SpecId"]} \
          #{city[:province]} #{city[:name]}:: #{style["MinPrice"]}".yellow
        end
      end

      storage(series_id, price_data)
    end

    def self.storage(series_id, price)
      Style.find_or_initialize_by(series_id: series_id)
        .update_attributes(price: price)
    end

    def self.prices
      Style.all.each do |style|
        next unless style.ids.length > 0
        price(style.series_id, style.ids)
      end
    end

    def self.json_parse(text)
      V8::Context.new.eval("#{text}CityArr;").to_a
    end

    def self.fetch(url)
      puts "==> Fetch #{url}".green

      response = RestClient.get url
      response.encode!(
        "UTF-8", "GB2312",
        undef: :replace, replace: "?", invalid: :replace)
      Nokogiri::HTML.parse response
    end
  end
end
# rubocop:enable Rails/Output,Metrics/AbcSize
