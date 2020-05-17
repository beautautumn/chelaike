class Car < ActiveRecord::Base
  class SyncService
    SyncResult = Struct.new(:state, :contactor, :published_car_url, :errors, :view_info)
    ForbiddenResult = Struct.new(:forbidden, :reason)

    attr_reader :car

    def initialize(user_id, car_id)
      @user_id = user_id
      @car = Car.find(car_id)
    end

    def sync_states
      # [ { platform: 'yiche', status: { state: 'processing', errors: [] },
      # contactor: 'xxx', view_info: '11/122',
      # forbidden: true,
      # reaseon: "asdfdfsa" }
      # ]

      [:che168, :yiche, :com58].inject([]) do |arr, platform|
        arr << forbidden_function(platform)

        # peter at 2016.8.17 暂时禁用
        # forbidden_result = check_forbidden_result(platform)
        # sync_result = get_sync_result(platform)

        # backend_url = publish_service(platform).backend_url
        # # backend_url = ""

        # arr << { platform: platform,
        #          status: { state: sync_result.state, errors: sync_result.errors },
        #          contactor: sync_result.contactor,
        #          view_info: sync_result.view_info,
        #          published_car_url: sync_result.published_car_url,
        #          backend_url: backend_url,
        #          forbidden: forbidden_result.forbidden,
        #          reason: forbidden_result.reason,
        #          is_bind_success: platform_binded?(platform)
        #        }
      end
    end

    private

    # peter: 临时代码，发车功能修复后删除这个方法
    def forbidden_function(platform)
      forbidden_result = ForbiddenResult.new(true, "发车功能维护中，暂时不能使用")
      sync_result = SyncResult.new("unsynced", "", "", [], "")
      backend_url = ""

      { platform: platform,
        status: { state: sync_result.state, errors: sync_result.errors },
        contactor: sync_result.contactor,
        view_info: sync_result.view_info,
        published_car_url: sync_result.published_car_url,
        backend_url: backend_url,
        forbidden: forbidden_result.forbidden,
        reason: forbidden_result.reason,
        is_bind_success: platform_binded?(platform)
      }
    end

    def get_sync_result(platform)
      record = car.car_publish_records
                  .where(type: "publish_car/#{platform}_record".classify, current: true)
                  .first
      return SyncResult.new("unsynced", "", "", [], "") unless record

      car_url = if record.state == "finished"
                  publish_service(platform).published_car_url(record.published_id)
                else
                  ""
                end
      SyncResult.new(record.state,
                     record.contactor,
                     car_url,
                     [], # errors 预留
                     ""  # view_info 预留
                    )
    end

    def platform_binded?(platform)
      company = User.find(@user_id).company
      profile = company.platform_profile
      return false if profile.blank?
      profile.binded?(platform)
    end

    def check_forbidden_result(platform)
      missings = publish_service(platform).validate_missings(@car)

      image_urls = missings.select { |hash| hash.fetch(:field_name).to_s == "image_urls" }

      image_urls_value = image_urls.blank? ? "" : image_urls.first.fetch(:values).first

      driver_image_url_value = if platform.to_sym.in?([:yiche, :com58])
                                 missing_driver = missings.select do |hash|
                                   hash.fetch(:field_name).to_s == "driver_image_url"
                                 end
                                 if missing_driver.blank?
                                   ""
                                 else
                                   missing_driver.first.fetch(:values, [""]).first
                                 end
                               end

      if image_urls_value.blank? && driver_image_url_value.blank?
        return ForbiddenResult.new(false, "")
      end
      reasons = [image_urls_value, driver_image_url_value].join("\n")
      ForbiddenResult.new(true, reasons)
    end

    def publish_service(platform)
      Publisher::PublishService.new(@user_id, platform)
    end
  end
end
