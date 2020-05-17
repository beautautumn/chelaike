module Util
  class Date
    class << self
      def date_different(date1, date2)
        (date1.to_date - date2.to_date).to_i
      end

      def parse_date_string(date_string)
        if date_string.present?
          date_string.is_a?(String) ? Time.zone.parse(date_string) : date_string
        end
      rescue ArgumentError
        "#{date_string}-01"
      end

      def maintence_date(attr_date)
        days = (Time.zone.today - attr_date.to_date).to_i
        if days == 0
          "今天"
        elsif days == 1
          "昨天"
        elsif days < 7
          "#{days}天前"
        elsif Time.zone.today.year != attr_date.year
          attr_date.strftime("%F")
        else
          attr_date.strftime("%m-%d")
        end
      end

      def token_bill_date(attr_date)
        days = (Time.zone.today - attr_date.to_date).to_i
        if days == 0
          "今天"
        elsif days == 1
          "昨天"
        else
          "周#{date_str(attr_date.wday)}"
        end
      end

      def token_bill_time(attr_date)
        days = (Time.zone.today - attr_date.to_date).to_i
        if days == 0
          attr_date.strftime("%H:%M")
        elsif days == 1
          attr_date.strftime("%H:%M")
        else
          attr_date.strftime("%m-%d")
        end
      end

      private

      def date_str(num)
        { "1" => "一",
          "2" => "二",
          "3" => "三",
          "4" => "四",
          "5" => "五",
          "6" => "六",
          "7" => "日"
        }.fetch(num.to_s)
      end
    end
  end
end
