module MaintenanceRecordSerializer
  class Mini < ActiveModel::Serializer
    attributes :id, :brand_name, :stored, :state, :car_id, :vin, :shared_url

    def shared_url
      shared_code = MaintenanceRecord.shared_key(object.provider_name, object.id)
      case Rails.env
      when "production", "dashboard"
        "http://evaluate.chelaike.com/#/#{shared_code}"
      else
        "http://evaluate.lina.server.chelaike.com/#/#{shared_code}"
      end
    end
  end
end
