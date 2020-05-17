require "rails_helper"

RSpec.describe V1::PublishersController do
  fixtures :all

  let(:github) { companies(:github) }
  let(:git) { users(:git) }
  let(:gtr) { cars(:gtr) }

  let(:aodi) { cars(:aodi) }

  before do
    login_user(git)
  end

  describe "GET /api/v1/cars/:car_id/publishers" do
    it "获取一键发车信息" do
      auth_get :index, car_id: gtr.id

      expect(response_json[:data][:che168_publish_record]).to be_present
    end
  end

  describe "GET /api/v1/cars/:car_id/publishers/che168_state_sync" do
    it "获取che168车辆状态信息" do
      allow(CarPublisher::Che168Worker::Helper)
        .to receive(:sync_che168_state).and_return("")

      auth_get :che168_state_sync, car_id: gtr.id

      expect(response_json[:data][:che168_publish_record]).to be_present
    end
  end

  describe "POST /api/v1/cars/:car_id/publishers/sync" do
    it "che168发车" do
      allow_any_instance_of(Publisher::Che168Service).to receive(:execute).and_return("")

      auth_post :sync, car_id: gtr.id, publishers: {
        che168: { syncable: false }
      }

      expect(response_json[:data][:che168_publish_record]).to be_present
    end
  end

  before do
    WebMock.allow_net_connect!
  end

  after do
    WebMock.allow_net_connect!
  end

  if ENV.key?("LOCAL_TEST")
    describe "POST publish" do
      def extra_attrs
        { vin: "11111111111111111",
          brand_name: "84",
          series_name: "2959",
          style_name: "117253",
          image_urls: [
            "http://image.chelaike.com/images/1e91bccbb34d05a4bc8662d995909c33.jpg",
            "http://image.chelaike.com/images/dc2ff46eaa3c924db383f8ce17389157.jpg",
            "http://image.chelaike.com/images/c43ae0168b3f93973df8a04fbf454394.jpg",
            "http://image.chelaike.com/images/2e2672306a616e8b6a9ea48891b1a61e.jpg"],
          annual_inspection_end_at: "2016-12-09",
          driver_image_url: "http://image.chelaike.com/images/2e2672306a616e8b6a9ea48891b1a61e.jpg"
        }
      end

      def platform
        :yiche
      end

      it "发车" do
        VCR.turned_off do
          github.create_platform_profile(
            data: yiche_profile.merge(che168_profile)
                               .merge(com58_profile)
          )
          aodi.update_columns(mileage: 8, mileage_in_fact: 9)
          auth_post :publish,
                    car_id: aodi.id,
                    relations: [platform: platform, contactor: "265875"],
                    extra_attrs: { yiche: extra_attrs }

          expect(response_json[:data][:che168_publish_record]).to be_present
        end
      end
    end
  end
end
