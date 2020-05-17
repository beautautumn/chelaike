module Etl
  module Transforms
    class Car
      def process(car)
        {
          # 车辆维度
          car_dimension: car_dimension(car),
          # 收购日期纬度
          acquired_at_dimension: acquired_at_dimension(car),
          # 收购事实
          acquisition_fact: acquisition_fact(car),
          # 出库事实
          out_of_stock_facts: out_of_stock_facts(car)
        }
      end

      private

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def car_dimension(car)
        {
          car_id: car.id,
          state: car.state,
          show_price_cents: car.show_price_cents || 0,
          online_price_cents: car.online_price_cents || 0,
          prepare_items_total_amount_cents: car.prepare_record.try(:total_amount_cents) || 0,
          brand_name: car.brand_name,
          series_name: car.series_name,
          age: car.age,
          deleted_at: car.deleted_at,
          stock_age: car.stock_age_days,
          shop_id: car.shop_id,
          company_id: car.company_id,
          estimated_gross_profit_cents: car.estimated_gross_profit_cents || 0,
          estimated_gross_profit_rate: car.estimated_gross_profit_rate || 0.0,
          sale_total_transfer_fee_cents: car.sale_transfer.try(:total_transfer_fee_cents) || 0,
          acquisition_total_transfer_fee_cents: car.acquisition_transfer.try(
            :total_transfer_fee_cents
          ) || 0
        }
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      def acquired_at_dimension(car)
        acquired_at = car.acquired_at
        return if acquired_at.blank?

        {
          acquired_at: acquired_at,
          acquired_at_date: acquired_at.to_date,
          acquired_at_year: acquired_at.year,
          acquired_at_month: acquired_at.month
        }
      end

      def acquisition_fact(car)
        {
          car_id: car.id,
          acquisition_price_cents: car.acquisition_price_cents || 0,
          acquirer_id: car.acquirer_id,
          acquisition_type: car.acquisition_type
        }
      end

      def stock_out_at_dimension(stock_out_at)
        return if stock_out_at.blank?

        {
          stock_out_at: stock_out_at.to_date,
          stock_out_at_month: stock_out_at.month,
          stock_out_at_year: stock_out_at.year
        }
      end

      def out_of_stock_facts(car)
        car.stock_out_inventories.map do |stock_out_inventory|
          {
            car_id: car.id,
            stock_out_inventory_id: stock_out_inventory.id,
            stock_out_inventory_type: stock_out_inventory.stock_out_inventory_type,
            mode: stock_out_mode(stock_out_inventory),
            seller_id: seller_id(car, stock_out_inventory),
            closing_cost_cents: stock_out_inventory.closing_cost_cents || 0,
            commission_cents: stock_out_inventory.commission_cents || 0,
            carried_interest_cents: stock_out_inventory.carried_interest_cents || 0,
            refund_price_cents: stock_out_inventory.refund_price_cents || 0,
            other_fee_cents: stock_out_inventory.other_fee_cents || 0,
            current: stock_out_inventory.current,

            stock_out_at_dimension: stock_out_at_dimension(
              stock_out_inventory.stock_out_at
            )
          }
        end
      end

      def seller_id(car, stock_out_inventory)
        # 如果是收购退车, 将销售员变成收购员, 因为收购的人会将车辆退车回去, 得到退款金额
        if stock_out_inventory.stock_out_inventory_type.acquisition_refunded?
          car.acquirer_id
        else
          stock_out_inventory.seller_id
        end
      end

      # 出库方式:
      # retail_cash retail_mortgage retail_others
      # wholesale acquisition_refunded others
      def stock_out_mode(stock_out_inventory)
        payment_type = stock_out_inventory.payment_type

        case
        when stock_out_inventory.sales_type == "retail"
          # 零售(其他) 零售(全款), 零售(按揭)
          payment_type.blank? ? "retail_others" : "retail_#{payment_type}"
        when stock_out_inventory.sales_type == "wholesale"
          "wholesale" # 批发
        when stock_out_inventory.stock_out_inventory_type == "acquisition_refunded"
          "acquisition_refunded" # 收购退车
        when stock_out_inventory.stock_out_inventory_type == "driven_back"
          "driven_back" # 车主开回
        else
          "others"
        end
      end
    end
  end
end
