require "rails_helper"

RSpec.describe V1::AllianceDashboard::AlliancesController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:chuche_alliance) { alliances(:chuche) }
  let(:tianche) { companies(:tianche) }

  before do
    chuche_alliance.add_companies([tianche])
    chuche_alliance.update(alliance_company: alliance_tianche)

    login_user(alliance_zhangsan)
  end

  describe "GET show" do
    it "显示这个联盟的基本信息" do
      auth_get :show
      expect(response_json[:data][:id]).to eq chuche_alliance.id
    end
  end

  describe "PUT update" do
    context "有权限操作" do
      before do
        give_authority(alliance_zhangsan, "联盟管理")
      end

      it "更新相应信息" do
        auth_put :update,
                 alliance: { name: "牛逼联盟", note: "就是牛逼", avatar: "asdf",
                             contact: "peter", contact_mobile: "12344321",
                             city: "hz", province: "zj",
                             district: "north",
                             water_mark_position: { p: 1, x: 10, y: 10 },
                             water_mark: "http://localhost.com"
                           }

        alliance_tianche.reload
        chuche_alliance.reload
        expect(alliance_tianche.city).to eq "hz"
        expect(alliance_tianche.province).to eq "zj"
        expect(alliance_tianche.water_mark_position).to eq("p" => "1", "x" => "10", "y" => "10")
        expect(chuche_alliance.name).to eq "牛逼联盟"
      end
    end

    context "没有权限操作" do
      it "不能更新" do
        auth_put :update,
                 alliance: { name: "牛逼联盟", note: "就是牛逼" },
                 company: { contact: "peter", contact_mobile: "12344321",
                            city: "hz", province: "zj",
                            district: "north"
                          }

        expect(response.status).to eq 403
      end
    end
  end
end
