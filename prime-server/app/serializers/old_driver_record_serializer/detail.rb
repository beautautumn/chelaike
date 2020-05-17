module OldDriverRecordSerializer
  class Detail < Basic
    attributes :vin, :order_id, :engine_num, :license_no, :id_numbers,
               :notify_at, :make, :insurance, :claims, :created_at,
               :updated_at, :total_records_count, :claims_count,
               :record_abstract, :claims_abstract, :latest_claim_date,
               :claims_total_fee_yuan, :meter_error, :smoke_level,
               :year, :nature, :generated_date, :max_mileage
  end
end
