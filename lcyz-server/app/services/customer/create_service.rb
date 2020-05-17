class Customer < ActiveRecord::Base
  class CreateService
    include ErrorCollector

    attr_reader :customer

    def initialize(user, params)
      @user = user
      @params = params

      prepare_params
    end

    def execute
      begin
        if @params.key?(:memory_dates)
          result = handle_memory_dates(@params.fetch(:memory_dates))
          @params[:memory_dates] = result
        end

        @customer = @user.customers.new(@params)

        @customer.save!
        associate_notifycations
      rescue
        @customer
      end

      self
    end

    private

    def handle_memory_dates(memory_dates_params)
      memory_dates_params = memory_dates_params.map(&:deep_symbolize_keys)

      memory_dates_params.each_with_object([]) do |dates_params, acc|
        create_notification(acc, dates_params)
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

    def associate_notifycations
      return if @customer.memory_dates.blank?
      noti_ids = @customer.memory_dates.map { |memory_date| memory_date.fetch("notification_id") }
      notifications = ExpirationNotification.where(id: noti_ids)
      notifications.map { |noti| noti.update!(associated: @customer) }
    end

    def parsed_date(date_str)
      year = DateTime.current.year
      Time.zone.parse("#{year}-#{date_str}").to_date
    end

    def company_notify_date(setting_date)
      ExpirationNotification.company_notify_date(@user.company, :memory_date, setting_date)
    end

    def prepare_params
      @params[:company_id] = @user.company_id
      @params[:user_id] = @user.id
      return unless @params[:phones]

      @params[:phones] -= [@params[:phone]]
      @params[:phones].uniq!
    end
  end
end
