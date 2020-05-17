module OldDriverRecordSerializer
  class Mini < ActiveModel::Serializer
    attributes :id, :make, :stored, :state, :car_id, :vin, :shared_url,
               :meter_error, :smoke_level,
               :year, :nature

    def shared_url
      shared_code = MaintenanceRecord.shared_key(object.provider_name, object.id)
      case Rails.env
      when "production", "dashboard"
        # "http://share.chelaike.com/insurance/#{shared_code}"
        "http://share.lcyzauto.com/insurance/#{shared_code}"
      when "bm_production"
        "http://bm_share.chelaike.cn/insurance/#{shared_code}"
      else
        "http://share.lina.server.chelaike.com/insurance/#{shared_code}"
      end
    end
  end
end
