module OldDriverRecordSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :make, :vin, :state, :user_name,
               :token_price, :state_info, :allow_share

    def allow_share
      false
    end

    attribute :format_last_fetch_at, key: :date
  end
end
