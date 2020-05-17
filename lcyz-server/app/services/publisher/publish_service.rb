# 同步某一个平台
module Publisher
  class PublishService
    PublishError = Class.new(StandardError)

    def initialize(user_id, platform)
      @platform = platform
      @user = User.find user_id
      @company = @user.company
    end

    def brands
      cache_info("brands") { publisher.brands }
    end

    def series(brand_id)
      cache_info("series", brand_id) { publisher.series(brand_id) }
    end

    def styles(series_id)
      cache_info("styles", series_id) { publisher.styles(series_id) }
    end

    def published_car_url(published_id)
      publisher.blank? ? "" : publisher.published_car_url(published_id)
    end

    def backend_url
      publisher = "car_publisher/#{@platform}".classify
                                              .constantize
                                              .new("", "")
      publisher.backend_url
    end

    def bind_account(username: nil, password: nil, data: nil)
      platform_profile = @company.platform_profile || @company.create_platform_profile
      platform_profile.update_profile(@platform, data)

      begin
        publisher = "car_publisher/#{@platform}".classify
                                                .constantize
                                                .new(username, password)
        publisher.login

        contacts = publisher.contacts if @platform.to_s.in?(%w( che168 yiche ))

        platform_profile.update_extras(
          @platform,
          bind_time: Time.zone.now,
          is_success: true,
          contacts: contacts
        )

      rescue CarPublisher::LoginError
        platform_profile.update_extras(@platform, is_success: false)
        raise CarPublisher::LoginError
      end
    end

    def validate_missings(car)
      car_params = construct_car_params(car)
      return [] if publisher.blank?
      publisher.validate_missings(car_params)
    end

    def create(car_id, extra_attrs, contact_value)
      publish_record = stale_publish_records(car_id, contact_value)

      begin
        publish_record.update!(state: "processing")
        published_id = publisher.create(
          car_publish_params(car_id, extra_attrs, contact_value)
        )
      rescue => e
        publish_failed(publish_record, extra_attrs, e)
      end

      publish_record.update!(published_id: published_id,
                             state: "finished"
                            )
    end

    def delete(car_id)
      car = Car.find(car_id)

      publish_record = car.public_send("publish_#{@platform}_record")
      published_car_id = publish_record.published_id
      publisher.delete(published_car_id)
    end

    private

    def car_publish_params(car_id, extra_attrs, contact_value)
      car = Car.find car_id

      car_attributes = construct_car_params(car).deep_stringify_keys
      extra_attrs = extra_attrs.deep_stringify_keys

      car_attributes.merge(extra_attrs)
                    .merge(contact_params(contact_value))
                    .with_indifferent_access
    end

    def publish_failed(publish_record, extra_attrs, error)
      publish_record.update!(
        state: "failed",
        error_message: Array(error.message).join("\n")
      )
      raise PublishError, <<-MESSAGE.squish!
        #{@platform}发车失败，
        car_id: #{publish_record.car_id},
        extra_attrs: #{extra_attrs.inspect},
        message: #{error.message}
      MESSAGE
    end

    def stale_publish_records(car_id, contact_value)
      clazz = "publish_car/#{@platform}_record".classify.constantize

      current_records = PublishCar::CarPublishRecord.where(
        car_id: car_id,
        type: clazz.name.to_s,
        current: true
      )
      current_records.update_all(current: false) if current_records.present?

      clazz.create!(company_id: @company.id,
                    car_id: car_id,
                    user_id: @user.id,
                    state: "pending",
                    current: true,
                    contactor: contact_value
                   )
    end

    def cache_info(info_type, extra_id = nil)
      Rails.cache.fetch("car_publisher/#{@platform}/#{info_type}/#{extra_id}", expires_in: 1.day) do
        yield
      end
    end

    def construct_car_params(car)
      PublishCar::PlatformMatcher.new(@platform).construct_car_params(car)
    end

    def contact_params(contact_value)
      @company.platform_profile.contact_person_params(@platform, contact_value)
    end

    def publisher
      platform_profile = @company.platform_profile

      return if platform_profile.blank?
      return unless platform_profile.binded?(@platform)
      config = platform_profile.send(@platform)

      "car_publisher/#{@platform}".classify
                                  .constantize
                                  .new(config.fetch("username"),
                                       config.fetch("password"))
    end
  end
end
