module Etl
  module Sources
    class Car
      def initialize(options = {})
        @car_scope = case
                     when options[:car_id].present?
                       ::Car.where(id: options[:car_id])
                     when options[:incremental].present?
                       ::Car.where(
                         "updated_at >= ? ", Time.zone.yesterday.beginning_of_day
                       )
                     else
                       ::Car
                     end

        Rails.logger.info "count: #{@car_scope.count}"
      end

      # rubocop:disable Rails/Output
      def each
        eager_loads = [
          :prepare_record, :sale_transfer,
          :acquisition_transfer, :stock_out_inventories
        ]

        @car_scope.with_deleted.includes(*eager_loads).find_each(batch_size: 100) do |car|
          begin
            yield car
          rescue
            puts "车辆ID: #{car.id} 报错"
          end
        end
      end
      # rubocop:enable Rails/Output
    end
  end
end
