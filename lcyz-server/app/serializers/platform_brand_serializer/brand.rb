module PlatformBrandSerializer
  class Brand < ActiveModel::Serializer
    attributes :brand_name, :brand_code, :price, :status, :start_time, :end_time,
               :mode, :need_engine_number, :comment, :first_letter

    def status
      (Time.zone.now.strftime("%H:%M") > object.start_time.strftime("%H:%M")) &&
        (Time.zone.now.strftime("%H:%M") < object.end_time.strftime("%H:%M"))
    end

    def start_time
      object.start_time.strftime("%H:%M")
    end

    def end_time
      object.end_time.strftime("%H:%M")
    end

    def first_letter
      Pinyin.t(object.brand_name).first.upcase
    end
  end
end
