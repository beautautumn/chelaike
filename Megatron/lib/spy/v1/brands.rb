# rubocop:disable Rails/Output,Metrics/AbcSize
module Spy
  class Brands
    def self.import
      puts "==> Import Brands\n".light_blue

      urls.each { |url| storage(parse(fetch(url))) }

      puts "\n==> Mession Completed".light_red
    end

    def self.storage(brands)
      brands.each do |the_brand|
        next unless the_brand[:brand_name]

        puts "==> Storage brand:: #{the_brand[:brand_name]}}".blue
        the_brand[:manufacturers].each do |manufacturer|
          puts "\t+++ Manufacturer:: #{manufacturer[:manufacturer_name]}".light_green

          manufacturer[:series].each do |series|
            puts "\t\t*** Series:: #{series[:series_name]}".yellow
          end
        end

        Brand.find_or_initialize_by(brand_name: the_brand[:brand_name])
          .update_attributes(the_brand)
      end
    end

    def self.parse(doc)
      doc.css("dl").map do |e|
        {}.tap do |brand|
          brand[:brand_name] = e.css("dt > div > a").text
          brand[:first_letter] = PinYin.of_string(
            brand[:brand_name].gsub(/·/, "")
          )[0][0].downcase
          brand[:manufacturers] = []

          e.css("dd > div[class='h3-tit']").each do |m|
            brand[:manufacturers] << {}.tap do |manufacturer|
              manufacturer[:manufacturer_name] = m.text
              manufacturer[:series] = []

              m.next_element.css("li[id]").each do |s|
                series = {
                  series_id: s.attr("id")[1..-1],
                  series_name: s.css("h4 > a").text
                }

                manufacturer[:series] << series
              end
            end
          end
        end
      end
    end

    def self.fetch(url)
      puts "==> Fetch #{url}".green

      response = RestClient.get url
      response.encode!("UTF-8", "GB2312")
      Nokogiri::HTML.parse response
    end

    def self.urls
      ("a".."z").to_a.map do |char|
        "http://www.autohome.com.cn/grade/carhtml/#{char}.html"
      end
    end
  end
end
# rubocop:enable Rails/Output,Metrics/AbcSize
