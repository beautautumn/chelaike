# rubocop:disable Rails/Output,Metrics/AbcSize
module Spy
  module V2
    class Style
      def initialize
        @config = ""
        @option = ""
        @styles = []
        @series_code = 0
        @style_id = 0
      end

      def fetch
        puts "==> Fetch #{url1}".green

        response = RestClient.get url1
        @config = JSON.parse(response.encode!("UTF-8", "GB2312"))

        puts "==> Fetch #{url2}".green

        response = RestClient.get url2
        @option = JSON.parse(response.encode!("UTF-8", "GB2312"))

        self
      end

      def crawl
        puts "==> Fecth all styles configuration.".red
        ::Style.all.order(series_code: :asc).no_timeout.each do |style|
          puts "==> Series::#{style[:series_code]}".yellow

          @series_code = style[:series_code]
          @styles = { data: {}, series_code: @series_code }

          style[:styles].each do |s|
            s[:models].each do |m|
              @style_id = m[:id]
              @styles[:data][@style_id.to_s] = {}
              begin
                fetch.parse
              rescue
                puts "ERROR URL #{url1} or #{url2}"
              end
            end
          end

          storage
        end
        puts "==> Mission completed.".red

        "Your Garce."
      end

      def storage
        @styles[:data].each do |id, data|
          conf = StyleConfiguration.find_or_initialize_by(
            series_code: @styles[:series_code], code: id
          )

          conf.data = data
          conf.series_code = @styles[:series_code]
          conf.code = id
          
          conf.save
        end

        puts "==> Storage Finished.".green
      end

      def parse
        return self unless @config["result"] || @option["result"]

        id = @config["result"]["specid"].to_s
        @config["result"]["paramtypeitems"].each do |item|
          item_name = item["name"]

          item["paramitems"].each do |pitem|
            @styles[:data][id][item_name] = @styles[:data][id][item_name] || {}
            @styles[:data][id][item_name][pitem["name"]] = escape(pitem["value"])
          end
        end

        id = @option["result"]["specid"].to_s
        @option["result"]["configtypeitems"].each do |item|
          item_name = item["name"]

          item["configitems"].each do |citem|
            @styles[:data][id][item_name] = @styles[:data][id][item_name] || {}
            if item_name == "厂商"
              @styles[:data][id][item_name][citem["name"]] = citem["value"]
            else
              @styles[:data][id][item_name][citem["name"]] = escape(citem["value"])
            end
          end
        end

        puts "==> Styles:: Series ID:#{@series_code} Styles ID:#{id}".blue

        self
      end

      def escape(string)
        {
          "&lt;" => "<",
          "&gt;" => ">",
          "&amp;" => "&",
          "&nbsp;" => " ",
          "&quot;" => "\"",
          "●" => "(标配)",
          "○" => "(选配)",
          "^-$" => "无"
        }.each do |key, value|
          string.gsub!(/#{key}/, value)
        end

        string
      end

      def url1
        "https://cacheapi.che168.com/CarProduct/GetParam.ashx?specid=#{@style_id}"
      end

      def url2
        "https://cacheapi.che168.com/CarProduct/GetConfig.ashx?specid=#{@style_id}"
      end
    end
  end
end
# rubocop:enable Rails/Output,Metrics/AbcSize
