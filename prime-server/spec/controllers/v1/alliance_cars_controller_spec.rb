require "rails_helper"

RSpec.describe V1::AllianceCarsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:nolan) { users(:nolan) }
  let(:avengers) { alliances(:avengers) }
  let(:aodi) { cars(:aodi) }
  let(:git) { users(:git) }
  let(:noaodi) { alliances(:noaodi) }
  let(:gtr) { cars(:gtr) }
  let(:benz) { cars(:benz) }

  describe "GET /api/v1/alliances/:id/cars" do
    it "获取复仇者联盟所有车辆信息" do
      give_authority(zhangsan, "联盟车辆查询")
      login_user(zhangsan)
      auth_get :index, alliance_id: avengers.id

      expect(response_json[:data].size).to be > 0
    end

    it "木有奥迪联盟里, 不应该显示奥迪的信息" do
      give_authority(git, "联盟车辆查询")
      login_user(git)
      auth_get :index, alliance_id: noaodi.id
      expect(response_json[:data].find { |h| h[:id] == gtr.id }).to be_nil
    end
  end
end
