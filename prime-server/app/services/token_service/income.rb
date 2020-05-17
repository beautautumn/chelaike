module TokenService
  class Income
    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def charge(order)
      case order.action
      when "token"
        added = order.amount_yuan.to_d
      when "token_package"
        added = order.orderable.total_balance.to_d
      end

      @token.with_lock do
        order.update!(status: :success)
        @token.increment_balance!(order.token_type, added)
      end
      generate_operation_record(order, added)
      generate_token_bill!(order, added)
    end
    # TODO: 是不是还要处理一下“赠送车币”的情况？

    def refund(record, price)
      @token.with_lock do
        record.paying? && @token.increment!(:balance, price)

        record.turn_fail!
      end

      generate_token_bill_for_record(record, price)
    end

    private

    def generate_operation_record(order, added)
      OperationRecord.create(operation_record_type: :token_recharge,
                             user_id: order.user_id,
                             shop_id: order.shop_id,
                             company_id: order.company_id,
                             messages: { action: :notify,
                                         token: format("%.2f", added),
                                         title: "车币充值",
                                         info: "你充值的#{format("%.2f", added)}车币已到账，" \
                                               "当前剩余#{format("%.2f", @token.balance)}车币" })
    end

    def generate_token_bill!(order, added)
      owner_id = case order.token_type
                 when "user"
                   order.user_id
                 when "company"
                   order.company_id
                 end
      TokenBill.create!(
        state: :finished,
        action_type: :charge,
        payment_type: :income,
        amount: added,
        operator_id: order.user_id,
        action_abstraction: { title: "充值", detail: { channel: order.channel } },
        token_type: order.token_type,
        owner_id: owner_id,
        company_id: order.company_id,
        shop_id: order.shop_id
      )
    end

    def generate_token_bill_for_record(record, price)
      platform_str = record.platform_name

      TokenBill.create!(
        state: :finished,
        action_type: :maintenance_refund,
        payment_type: :income,
        amount: price,
        operator_id: record.try(:last_fetch_by) || record.try(:user_id),
        action_abstraction: { title: "维保退款-#{platform_str}",
                              detail: { platform: platform_str,
                                        record_id: record.id,
                                        vin: record.vin } },
        token_type: @token.token_type,
        owner_id: @token.owner_id,
        company_id: record.company_id,
        shop_id: record.shop_id
      )
    end
  end
end
