require "rails_helper"

RSpec.describe ExpirationNotificationService::Scan do
  fixtures :all

  let(:cruise_birth_date) { expiration_notifications(:cruise_birth_date) }
  let(:doraemon_seeking_aodi_insurance) do
    expiration_notifications(:doraemon_seeking_aodi_insurance)
  end
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:aodi) { cars(:aodi) }
  let(:tianche) { companies(:tianche) }

  describe ".scan" do
    before do
      ExpirationSetting.init(tianche)
      cruise_birth_date.update!(notify_date: Time.zone.parse("2017-03-10"))
      doraemon_seeking_aodi_insurance.update!(notify_date: Time.zone.parse("2017-03-10"))
      doraemon_seeking_aodi.update!(state: :completed, closing_car: aodi)
      travel_to Time.zone.parse("2017-03-10")
    end

    it "得到当天应该生成的消息" do
      expect do
        ExpirationNotificationService::Scan.scan
      end.to change { OperationRecord.count }.by 2
    end
  end
end
