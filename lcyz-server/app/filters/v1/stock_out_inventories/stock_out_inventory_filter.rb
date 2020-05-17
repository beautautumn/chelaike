module V1::StockOutInventories
  class StockOutInventoryFilter < BaseFilter
    def initialize(input_params)
      super

      # @type = @input_params[:stock_out_inventory][:stock_out_inventory_type]
      @type = "sold"
      @input_params[:stock_out_inventory][:stock_out_inventory_type] = @type
    end

    def execute
      @output_params = @input_params.require(:stock_out_inventory)
                                    .permit(*sold)
                                    # .permit(*(@type ? send(@type) : []))
    end

    private

    def sold
      columns = %w(
        stock_out_inventory_type completed_at seller_id customer_channel_id
        closing_cost_wan sales_type customer_location_province customer_location_city
        customer_location_address customer_name customer_phone customer_idcard
        proxy_insurance insurance_company_id commercial_insurance_fee_yuan
        compulsory_insurance_fee_yuan note payment_type carried_interest_wan
        transfer_fee_yuan commission_yuan other_fee_yuan total_transfer_fee_yuan
        invoice_fee_yuan
      )

      case @input_params[:stock_out_inventory][:payment_type]
      when "cash"
        columns << %w(deposit_wan remaining_money_wan)
      when "mortgage"
        columns << %w(
          mortgage_company_id down_payment_wan loan_amount_wan
          mortgage_period_months mortgage_fee_yuan foregift_yuan
        )
      end
    end

    def acquisition_refunded
      %w(stock_out_inventory_type refunded_at refund_price_wan note)
    end

    def driven_back
      %w(stock_out_inventory_type driven_back_at note)
    end

    def alliance
      %w(stock_out_inventory_type alliance_id company_id seller_id closing_cost_wan
         deposit_wan remaining_money_wan completed_at note to_shop_id)
    end

    def alliance_refunded
      %w(stock_out_inventory_type refunded_at refunded_price_wan)
    end
  end
end
