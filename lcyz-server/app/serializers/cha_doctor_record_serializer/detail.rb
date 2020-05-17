module ChaDoctorRecordSerializer
  class Detail < ActiveModel::Serializer
    attributes :id, :company_id, :car_id, :shop_id,
               :state, :user_name, :stored,
               :user_id, :fetch_at, :cha_doctor_record_hub_id,
               :last_cha_doctor_record_hub_id, :engine_num,
               :token_price, :vin_image, :created_at, :updated_at,
               :brand_name, :vin, :brand_name, :engine_no,
               :license_plate, :sent_at, :order_id, :make_report_at,
               :report_no, :report_details, :pc_url, :mobile_url,
               :fetch_info_at, :notify_at, :order_status,
               :order_message, :notify_status, :notify_message,
               :order_state, :notify_state, :series_name, :style_name,
               :summany_status_data, :allow_share

    def allow_share
      false
    end
  end
end
