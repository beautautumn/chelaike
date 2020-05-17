module V1::AllianceStockOutInventories
  class AllianceStockOutInventoryFilter < BaseFilter
    def initialize(input_params)
      super
    end

    def execute
      @output_params = @input_params.require(:alliance_stock_out_inventory)
                                    .permit(*(send @input_params[:action]))
    end

    private

    def create
      [:alliance_id, :to_company_id, :seller_id, :to_shop_id,
       :closing_cost_wan, :deposit_wan, :remaining_money_wan, :completed_at, :note]
    end

    def update
      [:refunded_at, :refunded_price_wan]
    end
  end
end
