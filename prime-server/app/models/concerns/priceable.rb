module Priceable
  extend ActiveSupport::Concern

  module ClassMethods
    def price_yuan(*columns)
      priceable columns, unit: :yuan
    end

    def price_wan(*columns)
      priceable columns, unit: :wan
    end

    def priceable(columns, unit: :wan,
                  monetize_options: {
                    allow_nil: true,
                    numericality: { greater_than_or_equal_to: 0 }
                  })

      Array(columns).each do |column|
        column_name = "#{column}_#{unit}"
        database_column = "#{column}_cents"

        unless monetized_attributes[column].present? # 允许 万/元 同时存在
          monetize database_column, monetize_options
        end

        define_method "#{column_name}=" do |price_value|
          super(price_value) if has_attribute?(column_name)

          if price_value.present?
            price_cents = price_value.to_f * Util::ExchangeRate.cents_by_unit(unit)
          end

          self[database_column] = price_cents.try(:to_i)
        end

        define_method column_name do
          cent = self[database_column]
          if cent.present?
            price = Util::ExchangeRate.cents_conversion_by(cent, unit)
            # 如果是整万元, 输出整数, 否则为浮点数
            price.to_i == price ? price.to_i : price
          end
        end
      end
    end
  end
end
