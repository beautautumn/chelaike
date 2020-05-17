require "rails_helper"

RSpec.describe EasyLoan::SessionsController, type: :controller do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:code) { "123456" }

  describe "POST code" do
    before do
      allow_any_instance_of(SmsService).to receive(:code).and_return(code)

      zhangsan.update_column(:expired_at, Time.zone.now + 9.minutes)
      sms_object = SmsService.new(zhangsan.phone)
      zhangsan.update_column(:token, sms_object.code)

      cms = "您的登录验证码是：#{zhangsan.token} ，十分钟内有效。"
      allow(Yunpian).to receive(:send_to!).with(zhangsan.phone, cms)
    end

    it "send message" do
      VCR.use_cassette("send_message") do
        post :code, phone_number: zhangsan.phone
        expect(response.status).to eq 200
      end
    end
  end
end
