module ExpirationNotificationService
  class Intention
    attr_accessor :intention, :user

    def initialize(intention, user)
      @intention = intention
      @user = user
    end

    def execute
      [:annual_inspection, :insurance, :mortgage].each do |notify_type|
        setting_date = @intention.send("#{notify_type}_notify_date")
        next unless setting_date

        notify_record = ExpirationNotification.where(
          associated: @intention,
          notify_type: notify_type
        ).first

        setting = @intention.company.expiration_settings.where(notify_type: notify_type).first
        if notify_record
          notify_record.update_notify_date!(setting, setting_date)
        else
          notify_date = ExpirationNotification.company_notify_date(
            @user.company,
            notify_type,
            setting_date
          )
          # TODO: 这里是不是可以移到其他地方去创建
          ExpirationNotification.create!(
            associated: @intention,
            notify_type: notify_type,
            notify_name: notify_type,
            setting_date: setting_date,
            notify_date: notify_date,
            user_id: @user.id,
            company_id: @user.company_id,
            actived: true
          )
        end
      end
    end
  end
end
