# 每天扫描所有的到期提醒，生成 operation_record
module ExpirationNotificationService
  class Scan
    class << self
      def scan
        today_notifications = ExpirationNotification.where(notify_date: Time.zone.today)
        today_notifications.each do |noti|
          create_operation_record(noti)
          update_notify_date(noti)
        end
      end

      private

      def update_notify_date(noti)
        noti.update_notify_date!(noti.notify_setting)
      end

      def create_operation_record(noti)
        user = noti.notify_user
        obj = noti.associated

        case obj.class.name
        when "Customer"
          create_customer_operation(obj, noti, user)
        when "Intention"
          create_intention_operation(obj, noti, user)
        end
      end

      def create_customer_operation(obj, noti, user)
        setting_date = noti.setting_date
        setting_date_str = "#{setting_date.month}月#{setting_date.day}日"

        gender = obj.gender || "male"

        message_text = <<-TXT
          #{setting_date_str}是#{obj.name}#{gender_str(gender)}的#{noti.notify_name}
        TXT

        create_record(
          obj_type: "customer",
          text: message_text,
          user: user,
          obj: obj,
          noti: noti
        )
      end

      def create_intention_operation(obj, noti, user)
        closing_car = obj.closing_car
        customer_name = obj.customer_name

        plate = closing_car.current_plate_number
        notify_type_str = noti.notify_type_str
        setting_date = noti.setting_date
        setting_date_str = "#{setting_date.year}年#{setting_date.month}月#{setting_date.day}日"

        message_text = <<-TXT
          #{customer_name} #{gender_str(obj.gender.to_sym)} 车牌为#{plate}的汽车<br>
          #{notify_type_str}即将到期<br>
          #{notify_type_str}到期时间：#{setting_date_str}
        TXT

        create_record(
          obj_type: "intention",
          text: message_text,
          user: user,
          obj: obj,
          noti: noti
        )
      end

      def create_record(obj_type:, text:, user:, obj:, noti:)
        OperationRecord.create!(
          operation_record_type: :expiration_notification,
          user_id: user.id,
          shop_id: user.shop_id,
          company_id: noti.company_id,
          messages: {
            title: "到期提醒",
            obj_type: obj_type,
            obj_id: obj.id,
            text: text.squish
          }
        )
      end

      def gender_str(gender)
        {
          female: "女士",
          male: "先生"
        }.fetch(gender.to_sym)
      end
    end
  end
end
