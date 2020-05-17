module CheRongYiSerializer
  module AccreditedRecordSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :debtor_id, :allow_part_repay,
                 :limit_amount_cents, :in_use_amount_cents,
                 :funder_company_id, :created_at,
                 :updated_at, :single_car_rate, :sp_company_id,
                 :limit_amount_wan, :in_use_amount_wan,
                 :funder_company_name, :latest_limit_amout_wan,
                 :total_current_credit_wan,
                 :current_credit_wan,
                 :unused_amount_wan
    end
  end
end
