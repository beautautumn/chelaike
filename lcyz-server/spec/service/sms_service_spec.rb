require "rails_helper"

RSpec.describe SmsService do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }

  context "initialize sms service" do
    it "phone number don't match any easy_loan_users" do
      expect { SmsService.new("15012626165") }.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "within 60 seconds sent message raise Error" do
      zhangsan.update_column(:expired_at, Time.zone.now + 10.minutes)
      zhangsan.reload.expired_at
      expect { SmsService.new("13800138000") }.to raise_error(EasyLoan::User::TokenExpired)
    end

    it "initialize sms service object success" do
      zhangsan.update_column(:expired_at, Time.zone.now + 9.minutes)
      expect(SmsService.new("13800138000")).to be_an_instance_of SmsService
    end
  end

  context "send message" do
    before do
      zhangsan.update_attributes(expired_at: Time.zone.now + 9.minutes, phone: "15012626164")
      @service_object = SmsService.new(zhangsan.phone)

      zhangsan.update_column(:token, @service_object.code)
      cms = "您的登录验证码是：#{@service_object.code} ，十分钟内有效。"
      allow(Yunpian).to receive(:send_to!).with(zhangsan.phone, cms)
    end

    it "send message successfully" do
      @service_object.send_cms

      expect(zhangsan.token).to eq @service_object.user.token
    end
  end
end
