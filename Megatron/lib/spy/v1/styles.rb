# rubocop:disable Rails/Output,Metrics/AbcSize
module Spy
  class Styles
    def self.import
      puts "==> Import Styles\n".light_blue

      urls.each { |url_info| storage(url_info[0], parse(fetch(url_info[1]))) }
      series.map do |s|
        doc = fetch("http://www.autohome.com.cn/#{s}/sale.html")
        doc.css(".models_nav").each do |n|
          url_info = [s, "http://www.autohome.com.cn/#{n.css("a")[1].attribute("href")}"]
          storage(url_info[0], parse(fetch(url_info[1])))
        end
      end

      puts "\n==> Mession Completed".light_red
    end

    def self.storage(series_id, styles)
      return unless series_id

      puts "==> Storage styles [[#{styles[:ids].join(",")}]]'\
      ' of series:: #{series_id}".blue

      styles[:series_id] = series_id
      Style.find_or_initialize_by(series_id: styles[:series_id])
        .update_attributes(styles)
    end

    def self.parse(doc)
      ids, option, config = json_parse(doc)
      styles = { data: {}, ids: ids }
      ids.each { |id| styles[:data][id] = {} }

      return styles unless config[:result] || option[:result]

      config[:result][:paramtypeitems].each do |item|
        item_name = item[:name]

        item[:paramitems].each do |pitem|
          pitem[:valueitems].each do |vitem|
            id = vitem[:specid]

            styles[:data][id][item_name] = styles[:data][id][item_name] || {}
            styles[:data][id][item_name][pitem[:name]] = escape(vitem[:value])
          end
        end
      end

      option[:result][:configtypeitems].each do |item|
        item_name = item[:name]

        item[:configitems].each do |citem|
          citem[:valueitems].each do |vitem|
            id = vitem[:specid]

            styles[:data][id][item_name] = styles[:data][id][item_name] || {}
            styles[:data][id][item_name][citem[:name]] = escape(vitem[:value])
          end
        end
      end

      styles
    end

    def self.escape(string)
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

    def self.json_parse(doc)
      cxt = V8::Context.new

      begin
        js = doc.css(".footer_auto").first.next_element.next_element.text
      rescue
        js = "var specIDs = [];var option = {};var config = {};"
      end

      [
        cxt.eval("#{js}specIDs;").to_a,
        JSON.parse(cxt.eval("#{js}JSON.stringify(option);")).with_indifferent_access,
        JSON.parse(cxt.eval("#{js}JSON.stringify(config);")).with_indifferent_access
      ]
    end

    def self.series
      series = []
      Brand.all.each do |brand|
        brand.manufacturers.each do |m|
          m[:series].each { |s| series << s[:series_id] }
        end
      end

      series
    end

    def self.urls
      series.map { |s| [s, "http://car.autohome.com.cn/config/series/#{s}.html"] }
    end

    def self.suspension_sale_urls
      urls = []

      series.map do |s|
        doc = fetch("http://www.autohome.com.cn/#{s}/sale.html")
        doc.css(".models_nav").each do |n|
          urls << [s, "http://www.autohome.com.cn/#{n.css("a")[1].attribute("href")}"]
        end
      end

      urls
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
