module Util
  class ExchangeRate
    def self.cents_by_unit(unit = :wan)
      unit == :wan ? 1_000_000.0 : 100.0
    end

    def self.cents_conversion_by(cent, unit = :wan)
      (cent / cents_by_unit(unit)).round(4)
    end
  end
end
