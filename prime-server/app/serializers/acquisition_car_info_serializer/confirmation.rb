module AcquisitionCarInfoSerializer
  class Confirmation < ActiveModel::Serializer
    attributes :acquisition_price_wan, :acquired_at,
               :company_id, :shop_id, :alliance_id,
               :cooperate_companies

    attribute :car_id

    def car_id
      instance_options[:car_id]
    end
  end
end
