module EasyLoanSerializer
  class AccreditedRecordSerializer::Basic < ActiveModel::Serializer
    attributes :id, :limit_amount_wan, :in_use_amount_wan,
               :funder_company_id, :created_at, :updated_at,
               :single_car_rate, :sp_company_id
  end
end
