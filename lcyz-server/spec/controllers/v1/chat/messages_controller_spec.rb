require "rails_helper"

RSpec.describe V1::Chat::MessagesController do
  fixtures :all

  let(:nolan) { users(:nolan) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:warner) { companies(:warner) }
  let(:tianche) { companies(:tianche) }
  let(:nolan_disabled) { users(:nolan_disabled) }
  let(:username) { "DavidFincher" }
  let(:password) { "ILoveYourFilms." }
  let(:phone) { "18668237884" }
  let(:pixar) { shops(:pixar) }
  let(:alliance_avengers) { alliances(:avengers) }
  let(:alliance_gcd) { alliances(:gcd) }

  before do
    login_user(zhangsan)
  end

  describe "private_publish" do
    it "发送单聊消息" do
      VCR.use_cassette("rongcloud/private_message") do
        auth_post :private_publish,
                  from_user_id: zhangsan.id,
                  to_user_id: lisi.id,
                  object_name: :text,
                  content: { content: "hello", extra: "customized" }
        expect(response_json[:data]).to eq "ok"
      end
    end
  end
end
