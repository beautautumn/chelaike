module Dw
  module Analysis
    class AcquisitionType < Base
      def stock_info(conditions)
        fact = Dw::AcquisitionFact

        fields = [
          Fields.acquisition_count,
          Fields.acquisition_amount,
          Fields.acquisition_type
        ]

        organize_by_types(
          search_by(
            fact, fields, acquisition_dimensions, conditions,
            groups: Fields.acquisition_type
          )
        )
      end

      # rubocop:disable Metrics/MethodLength
      def organize_by_types(result)
        acquisition_types = []
        cars_total_count = 0
        total_acquisition_amount = 0

        result.each do |record|
          cars_total_count += record.fetch("acquisition_count")
          total_acquisition_amount += record.fetch("acquisition_amount").to_f
        end

        detail = {}.tap do |hash|
          result.each do |record|
            acquisition_type = record.fetch("acquisition_type")
            acquisition_count = record.fetch("acquisition_count").to_i
            acquisition_amount = record.fetch("acquisition_amount").to_f

            acquisition_types << acquisition_type

            hash[acquisition_type] = {
              acquisition_amount: acquisition_amount,
              acquisition_count: acquisition_count,
              cars_count_proportion: Util::Math::Percentage.execute(
                acquisition_count, cars_total_count
              ),
              acquisition_amount_proportion: Util::Math::Percentage.execute(
                acquisition_amount, total_acquisition_amount
              )
            }
          end
        end

        {
          detail: detail,
          acquisition_types: acquisition_types,
          cars_total_count: cars_total_count,
          total_acquisition_amount: total_acquisition_amount
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
