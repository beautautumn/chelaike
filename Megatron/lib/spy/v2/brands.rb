# rubocop:disable Rails/Output
module Spy
  module V2
    class Brands
      def initialize
        @brands = []
        @data = ""
      end

      def crawl
        puts "==> Fecth all brands.".red
        fetch.parse.storage
        puts "==> Mission completed.".red

        "Your Garce."
      end

      def storage
        @brands.each do |brand|
          Brand.where(code: brand[:code]).first.present? ? next : Brand.create(brand)
        end

        puts "==> Storage Finished.".green

        self
      end

      def parse
        brand = {}

        V8::Context.new.eval("#{@data}fct['0'];")
          .to_s.split(",").each_with_index do |e, i|
          type = i % 2

          if type == 0
            brand[:code] = e
          else
            brand[:first_letter], brand[:name] = e.split(" ")
            @brands << brand

            puts "==> Brand:: "\
            "#{brand[:code]} #{brand[:first_letter]} #{brand[:name]}".light_blue

            brand = {}
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
        @url ||= "http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx"\
        "?needData=1"
      end
    end
  end
end
# rubocop:enable Rails/Output
