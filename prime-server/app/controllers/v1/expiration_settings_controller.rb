# 公司设置到期提醒时间
module V1
  class ExpirationSettingsController < ApplicationController
    before_action do
      authorize ExpirationSetting
    end

    def index
      settings = current_user.company.expiration_settings

      render json: settings,
             each_serializer: ExpirationSettingSerializer::Basic,
             root: "data"
    end

    def update
      setting = ExpirationSetting.find(params[:id])
      setting.update!(expiration_setting_params)

      company = current_user.company
      notifications = ExpirationNotification.where(
        company_id: company.id,
        notify_type: setting.notify_type
      )

      notifications.map { |noti| noti.update_notify_date!(setting) }

      render json: setting,
             serializer: ExpirationSettingSerializer::Basic,
             root: "data"
    end

    private

    def expiration_setting_params
      params.require(:expiration_setting).permit(:first_notify, :second_notify, :third_notify)
    end
  end
end
