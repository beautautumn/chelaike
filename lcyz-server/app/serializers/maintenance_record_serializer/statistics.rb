module MaintenanceRecordSerializer
  class Statistics < ActiveModel::Serializer
    attributes :id, :user_name, :fetch_at, :stored, :car_id,
               :platform, :car_name, :token_price

    attribute :real_vin, key: :vin

    def fetch_at
      object.last_fetch_at.strftime("%Y-%m-%d")
    end

    def id
      "#{object.class.name}-#{object.id}"
    end

    def platform
      {
        "AntQueenRecord" => "蚂蚁女王",
        "MaintenanceRecord" => "车鉴定"
      }.fetch(object.class.name, "车鉴定")
    end
  end
end
