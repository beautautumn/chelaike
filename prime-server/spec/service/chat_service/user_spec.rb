require "rails_helper"

RSpec.describe ChatService::User do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:zhaoliu) { users(:zhaoliu) }
  let(:wangwu) { users(:wangwu) }
  let(:git) { users(:git) }
  let(:alliance_avengers) { alliances(:avengers) }
  let(:github) { companies(:github) }
  let(:tianche) { companies(:tianche) }
  let(:xiaocheche) { User.find_by(username: "xiaocheche") }

  describe "#rc_token" do
    it "如果DB里已有token, 直接返回这个token" do
      zhangsan.update(rc_token: "asdf")
      service = ChatService::User.new(zhangsan)
      expect(service.rc_token).to eq zhangsan.rc_token
    end

    it "如果DB里没有token，访问融云api，得到token，并保存到DB" do
      zhangsan.update(rc_token: nil)

      service = ChatService::User.new(zhangsan)

      VCR.use_cassette("rongcould/user") do
        rc_token = service.rc_token
        expect(rc_token).to be_present
        expect(zhangsan.reload.rc_token).to eq rc_token
      end
    end
  end

  describe "#avaliable_users" do
    before do
      tianche.alliances.clear
      github.alliances.clear
      alliance_avengers.companies.clear
      alliance_avengers.add_companies([tianche, github])
    end

    it "得到所有跟这个用户可进行私聊的用户" do
      service = ChatService::User.new(zhangsan)
      users = service.avaliable_users
      expect(users).to match_array [zhaoliu, lisi, wangwu, zhangsan, git, xiaocheche]
    end
  end

  describe "#same_alliance_users" do
    before do
      tianche.alliances.clear
      github.alliances.clear
      alliance_avengers.companies.clear
      alliance_avengers.add_companies([tianche, github])
    end

    it "得到同联盟里其他公司的用户" do
      service = ChatService::User.new(zhangsan)
      users = service.same_alliance_users
      expect(users).to match_array [git]
    end
  end
end
