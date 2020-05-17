# rubocop:disable Rails/Output,Metrics/AbcSize
module Spy
  module V2
    class Styles
      def initialize
        @styles = []
        @data = ""
        @series_code = 0
      end

      def crawl
        puts "==> Fecth all styles.".red
        ::Series.all.each do |series|
          puts "==> Series::#{series[:name]}".yellow

          # 超过10位汽车之家会报错，一般是自定义车型
          next if series[:code].blank? || series[:code].to_s.size > 10
          @series_code = series[:code]
          fetch.parse.storage
        end
        puts "==> Mission completed.".red

        "Your Garce."
      end

      def storage
        style = ::Style.find_or_initialize_by(series_code: @series_code)
        style.styles = compare_and_merge_styles(Array(style.styles), Array(@styles[:styles]))
        style.save

        puts "==> Storage Finished.".green

        self
      end

      def compare_and_merge_styles old_styles, new_styles
        unless old_styles == new_styles
          old_styles_hash, new_styles_hash, new_styles_value_hash = {}, {}, {}
          old_styles.each {|style| old_styles_hash[style["year"]] = style["models"].map{|s| s["id"] }.sort }
          new_styles.each {|style| new_styles_hash[style["year"]] = style["models"].map{|s| s["id"] }.sort }

          new_styles_value_array = new_styles.map{|style| style["models"] }.flatten
          new_styles_value_array.each { |style| new_styles_value_hash[style["id"]] = style["name"] }

          new_styles_hash.keys.each do |key|
            tmp_array = []
            need_add_keys = Array(new_styles_hash[key]) - Array(old_styles_hash[key])
            if need_add_keys.present?
              need_add_keys.each do |new_key|
                tmp_array << {"id"=> new_key, "name"=> new_styles_value_hash[new_key]}
              end

              if tmp_array.present?
                if old_styles.map{|style| style["year"] }.include? key
                  old_styles.each do |style|
                    style["models"] = style["models"] + tmp_array if style["year"] == key
                  end
                else
                  old_styles << {"year" => key, "models" => tmp_array}
                end
              end
            end
          end
        end
        old_styles
      end

      def parse
        @styles = {}

        @data = V8::Context.new.eval("JSON.stringify(#{@data})").to_s
        @styles[:styles] = JSON.parse(@data).map do |s|
          s = s.with_indifferent_access
          s.delete :maxlen
          s[:models] = s.delete :spec

          puts "==> Styles:: Series ID:#{@series_code} Year:#{s[:year]}"
          .magenta
          next if s[:year].empty?

          s[:models].each do |m|
            if m[:name].include?("款")
              m[:name].gsub!(/(.*)款/, s[:year])
            else
              m[:name] = "#{s[:year]} #{m[:name]}"
            end

            puts "#{m[:name]}    #{m[:id]}".light_blue
          end
          s
        end.compact
        @styles[:series_code] = @series_code

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
        "seriesGroupType=2&seriesid=#{@series_code}"
      end
    end
  end
end
# rubocop:enable Rails/Output,Metrics/AbcSize
