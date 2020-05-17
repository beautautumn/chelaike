module TokenBillSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :state, :action_type,
               :payment_type, :amount, :operator_id,
               :action_abstraction, :owner_id, :token_type,
               :company_id, :shop_id, :created_at, :updated_at,
               :date_str, :time_str
  end
end
