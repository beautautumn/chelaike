module Util
  module Math
    class Percentage
      extend ActiveSupport::NumberHelper

      def self.execute(numerator, denominator, precision: 1)
        denominator = denominator.to_f

        result = if denominator == 0
                   0
                 else
                   numerator.to_f / denominator * 100
                 end

        number_to_percentage(result, precision: precision)
      end

      def self.show(price, precision: 1)
        price = 0 if price.blank?

        number_to_percentage(price * 100, precision: precision)
      end
    end
  end
end
