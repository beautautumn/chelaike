require "rails_helper"

RSpec.describe V1::ExpirationSettingsController, type: :controller do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:cruise_birth_date) { expiration_notifications(:cruise_birth_date) }

  before do
    @settings = ExpirationSetting.init(tianche)
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET index" do
    it "得到一家公司里所有设置的到期提醒时间" do
      auth_get :index
      expect(response_json[:data].count).to eq 4
    end
  end

  describe "PUT update" do
    before do
      travel_to Time.zone.parse("2017-2-21")
    end

    it "可以更新节日提醒时间" do
      memory_date = tianche.expiration_settings.where(notify_type: :memory_date).first
      auth_put :update, id: memory_date.id,
                        expiration_setting: {
                          first_notify: 3,
                          second_notify: 2,
                          third_notify: 0
                        }

      expect(memory_date.reload.first_notify).to eq 3
    end

    it "如果公司里已有相应类型的到期提醒，要更新相应的提醒时间" do
      cruise_birth_date.update!(
        setting_date: Time.zone.parse("2017-03-10"),
        notify_date: Time.zone.parse("2017-03-01"),
        company_id: tianche.id
      )

      memory_date = tianche.expiration_settings.where(notify_type: :memory_date).first

      auth_put :update, id: memory_date.id,
                        expiration_setting: {
                          first_notify: 3,
                          second_notify: 2,
                          third_notify: 0
                        }

      expect(cruise_birth_date.reload.notify_date).to eq Time.zone.parse("2017-03-07").to_date
    end
  end
end
