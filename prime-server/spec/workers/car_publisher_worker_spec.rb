require "rails_helper"

RSpec.describe CarPublisher do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  it "获取验证码" do
    VCR.use_cassette("car_publisher_login_code") do
      result = CarPublisher::Che168Worker::Helper.login_code
      expect(result[:value]).to be_present
    end
  end
end
