module TokenService
  class Payout
    class TypeError < StandardError; end
    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def pay(action_type:, subject:, user:, amount:)
      raise TypeError unless action_type.to_s.in?(TokenBill.action_type.values)

      send("#{action_type}_process", subject, user, amount)
    end

    private

    def insurance_query_process(record, user, amount)
      platform_str = "查个车"

      token_bill = TokenBill.create!(
        state: :pending,
        action_type: :insurance_query,
        payment_type: :payout,
        amount: amount,
        operator_id: user.id,
        action_abstraction: { title: "保险查询-#{platform_str}",
                              detail: { platform: platform_str,
                                        record_id: record.id,
                                        vin: record.vin,
                                        detail_text: record.vin } },
        token_type: @token.token_type,
        owner_id: @token.owner_id,
        company_id: record.company_id,
        shop_id: record.shop_id
      )

      @token.with_lock do
        record.update!(token_type: @token.token_type,
                       token_id: @token.id)
        @token.decrement!(:balance, record.token_price)
        token_bill.update!(state: :finished)
      end
    end

    def maintenance_query_process(record, user, amount)
      platform_str = record.platform_name

      token_bill = TokenBill.create!(
        state: :pending,
        action_type: :maintenance_query,
        payment_type: :payout,
        amount: amount,
        operator_id: user.id,
        action_abstraction: { title: "维保查询-#{platform_str}",
                              detail: { platform: platform_str,
                                        record_id: record.id,
                                        vin: record.vin,
                                        detail_text: record.vin } },
        token_type: @token.token_type,
        owner_id: @token.owner_id,
        company_id: record.company_id,
        shop_id: record.shop_id
      )

      @token.with_lock do
        record.update!(token_type: @token.token_type,
                       token_id: @token.id)
        @token.decrement!(:balance, record.token_price)
        token_bill.update!(state: :finished)
      end
    end
  end
end
