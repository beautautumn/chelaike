module Etl
  module Destinations
    class Car
      def write(row)
        # 车辆维度
        car_dimension = build_car_dimension(row)

        # 收购事实
        build_acquisition_fact(row, car_dimension)

        # 出库事实
        build_out_of_stock_facts(row, car_dimension)
      end

      def close
      end

      private

      def build_car_dimension(row)
        params = row.fetch(:car_dimension)

        car_dimension = Dw::CarDimension.find_or_initialize_by(
          car_id: params.fetch(:car_id)
        )

        car_dimension.assign_attributes(params)
        car_dimension.save!

        car_dimension
      end

      def build_acquired_at_dimension(row)
        params = row.fetch(:acquired_at_dimension)
        return if params.blank?

        Dw::AcquiredAtDimension.find_or_create_by!(params)
      end

      def build_acquisition_fact(row, car_dimension)
        params = row[:acquisition_fact]

        acquisition_fact = Dw::AcquisitionFact.find_or_initialize_by(
          car_id: params[:car_id]
        )

        acquisition_fact.assign_attributes(params)
        acquisition_fact.car_dimension_id = car_dimension.id
        acquisition_fact.acquired_at_dimension_id = build_acquired_at_dimension(row).id

        acquisition_fact.save!
      end

      def build_stock_out_at_dimension(params)
        return if params.blank?

        Dw::StockOutAtDimension.find_or_create_by!(params)
      end

      def build_out_of_stock_fact(fact, car_dimension)
        stock_out_at_dimension_params = fact.delete(:stock_out_at_dimension)

        stock_out_at_dimension = build_stock_out_at_dimension(
          stock_out_at_dimension_params
        )

        out_of_stock_fact = Dw::OutOfStockFact.find_or_initialize_by(
          car_id: fact[:car_id],
          stock_out_inventory_id: fact[:stock_out_inventory_id]
        )
        out_of_stock_fact.assign_attributes(fact)
        out_of_stock_fact.car_dimension_id = car_dimension.id
        out_of_stock_fact.stock_out_at_dimension_id = stock_out_at_dimension.try(:id)

        out_of_stock_fact.save!
      end

      def build_out_of_stock_facts(row, car_dimension)
        row[:out_of_stock_facts].each do |fact|
          build_out_of_stock_fact(fact, car_dimension)
        end
      end
    end
  end
end
