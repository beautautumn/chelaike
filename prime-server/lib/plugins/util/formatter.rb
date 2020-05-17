module Util
  class Formatter
    def self.to_date(datetime)
      datetime.strftime("%F") if datetime
    end

    def self.parse_date(date)
      Time.zone.parse(date) if date
    end

    def self.to_month(datetime)
      datetime.strftime("%Y-%m") if datetime
    end

    def self.parse_month(month)
      Time.zone.parse("#{month}-01") if month
    end

    def self.to_string_date(datetime)
      datetime.strftime("%F") if datetime
    end

    def self.to_string_time(datetime)
      datetime.strftime("%F %T") if datetime
    end
  end
end
