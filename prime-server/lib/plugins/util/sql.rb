module Util
  class SQL
    def self.to_jsonb(key, value)
      "{\"#{key}\": \"#{value}\"}"
    end
  end
end
