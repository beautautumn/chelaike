module V1
  class AccreditedRecordsController < ApplicationController
    before_action do
      authorize EasyLoan::AccreditedRecord
    end

    def index
      company = current_user.company
      records = company.accredited_records

      init_total_amounts = { total_amount_wan: 0, total_in_use_wan: 0 }
      total_amounts = records.each_with_object(init_total_amounts) do |record, hash|
        hash[:total_amount_wan] += record.limit_amount_wan.to_f
        hash[:total_in_use_wan] += record.in_use_amount_wan.to_f
        hash
      end

      render json: records,
             each_serializer: EasyLoan::AccreditedRecordSerializer::Basic,
             root: "data",
             meta: {
               total_amount_wan: total_amounts[:total_amount_wan],
               total_in_use_wan: total_amounts[:total_in_use_wan]
             }
    end

    def show
    end
  end
end
