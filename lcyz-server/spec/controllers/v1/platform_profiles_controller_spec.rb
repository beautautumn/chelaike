require "rails_helper"

if ENV.key?("LOCAL_TEST")
  RSpec.describe V1::PlatformProfilesController do
    fixtures :companies, :users, :cars
    let(:github) { companies(:github) }
    let(:git) { users(:git) }
    let(:aodi) { cars(:aodi) }

    # let(:platform) { :yiche }
    let(:platform) { :com58 }

    before do
      login_user(git)

      WebMock.allow_net_connect!
    end

    after do
      WebMock.allow_net_connect!
    end

    def bind_all_platform
      github.create_platform_profile(data: yiche_profile.merge(che168_profile).merge(com58_profile))
    end

    describe "PUT update" do
      it "binds the profile for the company" do
        VCR.turned_off do
          auth_put :update, profile: {
            platform: :yiche,
            data: { username: "35050588@qq.com",
                    password: "z5814572",
                    default_description: "saeffdsa" }
          }

          expect(github.platform_profile.yiche["is_success"]).to be_falsy
        end
      end
    end

    describe "DELETE destroy" do
      it "unbinds the platform account" do
        profile = github.create_platform_profile data: yiche_profile
        auth_delete :destroy, platform: :yiche
        expect(profile.reload.yiche).to eq("default_description" => "description")
      end
    end

    describe "GET contacts" do
      it "returns list of contacts" do
        bind_all_platform
        VCR.turned_off do
          auth_get :contacts
          expect(response_json[:data]).to be_present
        end
      end
    end

    describe "GET validate_missings" do
      it "returns list of the missings attrs" do
        bind_all_platform
        VCR.turned_off do
          auth_get :validate_missings, platforms: [platform], car_id: aodi.id
          expect(response_json[:data]).to be_present
        end
      end
    end

    describe "GET brands" do
      it "returns list of the brands based on the platform" do
        bind_all_platform
        VCR.turned_off do
          auth_get :brands, platform: :platform
          expect(response_json[:data]).to be_present
        end
      end
    end

    describe "GET series" do
      it "returns list of the series based on the platform" do
        bind_all_platform
        VCR.turned_off do
          auth_get :series, platform: :platform, brand_id: "84"
          expect(response_json[:data]).to be_present
        end
      end
    end

    describe "GET sync_states" do
      it "returns the sync state of the platforms" do
        bind_all_platform
        VCR.turned_off do
          auth_get :sync_states, car_id: aodi.id
          expect(response_json[:data]).to be_present
        end
      end
    end
  end
end
