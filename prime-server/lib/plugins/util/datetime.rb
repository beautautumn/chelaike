module Util
  class Datetime
    def self.from_string_time(string_time)
      Time.zone.parse(Time.zone.now.to_date.to_s + " " + string_time)
    end

    def self.date_with_time_format(datetime)
      datetime.strftime("%Y-%m-%d %H:%M")
    end
  end
end
