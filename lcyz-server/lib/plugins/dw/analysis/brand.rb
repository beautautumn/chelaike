module Dw
  module Analysis
    class Brand < Base
      def stock_info(conditions)
        fact = Dw::AcquisitionFact

        fields = [
          Fields.brand_name,
          Dw::Analysis::Fields.acquisition_count,
          Dw::Analysis::Fields.acquisition_amount
        ]

        organize_acquisition_info(
          search_by(
            fact, fields, acquisition_dimensions, conditions,
            groups: Fields.brand_name,
            orders: "acquisition_amount DESC NULLS LAST"
          ), :brand_name
        )
      end

      def out_of_stock_info(conditions)
        fact = Dw::OutOfStockFact.state_out_of_stock.current

        fields = [
          Fields.brand_name,
          Fields.car_gross_profit,
          Fields.out_stock_count,
          Fields.out_stock_amount
        ]

        organize_out_of_stock_info(
          search_by(
            fact, fields, out_of_stock_dimensions, conditions,
            groups: Fields.brand_name,
            orders: "out_stock_amount DESC NULLS LAST"
          ), :brand_name
        )
      end
    end
  end
end
