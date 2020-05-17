# rubocop:disable Rails/Output
module Spy
  module V2
    class Series
      def initialize
        @series = []
        @data = ""
        @brand_code = 0
      end

      def crawl
        puts "==> Fecth all series.".red
        Brand.all.each do |brand|
          puts "==> Brand::#{brand[:name]}".yellow

          @brand_code = brand[:code]
          # TODO
          begin
            fetch.parse.storage
          rescue
            puts 'error!'
            next
          end
        end
        puts "==> Mission completed.".red

        "Your Garce."
      end

      def storage
        @series.each do |series|
          ::Series.where(code: series[:code]).first.present? ? next : ::Series.create(series)
        end

        puts "==> Storage Finished.".green

        self
      end

      def parse
        @series = []
        series = {}

        V8::Context.new.eval("#{@data}br['#{@brand_code}'];")
          .to_s.split(",").each_with_index do |e, i|
          type = i % 2

          if type == 0
            series[:code] = e
          else
            series[:manufacturer], series[:name] = e.split(" ", 2)
            series[:brand_code] = @brand_code
            @series << series

            puts "==> Series:: "\
            "#{series[:code]} #{series[:manufacturer]} #{series[:name]}".light_blue

            series = {}
          end
        end

        self
      end

      def fetch
        puts "==> Fetch #{url}".green

        response = RestClient.get url
        @data = response.encode!("UTF-8", "GB2312")

        self
      end

      def url
        "http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?"\
        "seriesGroupType=2&bid=#{@brand_code}"
      end
    end
  end
end
# rubocop:enable Rails/Output
