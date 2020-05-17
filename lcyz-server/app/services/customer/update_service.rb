class Customer < ActiveRecord::Base
  class UpdateService
    attr_accessor :customer

    def initialize(user, customer)
      @user = user
      @customer = customer
    end

    def update(customer_params)
      if customer_params.key?(:memory_dates)
        result = handle_memory_dates(customer_params.fetch(:memory_dates))
        # 将notification_id回写到记录里
        customer_params[:memory_dates] = result
      end

      @customer.update!(customer_params)

      self
    end

    private

    def handle_memory_dates(memory_dates_params)
      memory_dates_params = memory_dates_params.map(&:deep_symbolize_keys)

      memory_dates_params.each_with_object([]) do |dates_params, acc|
        if dates_params.key?(:notification_id)
          update_notification(acc, dates_params)
        else
          create_notification(acc, dates_params)
        end
      end
    end

    def create_notification(acc, dates_params)
      setting_date = parsed_date(dates_params.fetch(:date))
      notification = ExpirationNotification.create!(
        associated: @customer,
        notify_type: :memory_date,
        notify_name: dates_params.fetch(:name),
        setting_date: setting_date,
        notify_date: company_notify_date(setting_date),
        user_id: @user.id,
        company_id: @user.company_id,
        actived: true
      )

      acc << dates_params.merge(notification_id: notification.id)
    end

    def update_notification(acc, dates_params)
      notification_id = dates_params.fetch(:notification_id)
      notification = ExpirationNotification.find(notification_id)

      setting_date = parsed_date(dates_params.fetch(:date))
      notification.update!(
        notify_date: company_notify_date(setting_date)
      )

      acc << dates_params
    end

    def parsed_date(date_str)
      year = DateTime.current.year
      Time.zone.parse("#{year}-#{date_str}").to_date
    end

    def company_notify_date(setting_date)
      ExpirationNotification.company_notify_date(@user.company, :memory_date, setting_date)
    end
  end
end
