module Util
  module Math
    class Addition
      def self.execute(value, added_value)
        return added_value if value.blank?

        value + added_value
      end
    end
  end
end
