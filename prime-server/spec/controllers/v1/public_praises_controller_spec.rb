require "rails_helper"

RSpec.describe V1::PublicPraisesController do
  include PublicPraiseHelper
  fixtures :all

  let(:aodi) do
    car = cars(:aodi)
    car.update_columns(style_name: "2016款 Sportback 35 TFSI 进取型")

    car
  end

  let(:aodi_public_praise_sumup) { public_praise_sumups(:aodi_public_praise_sumup) }

  before do
    mock_requests
  end

  describe "GET /api/v1/cars/:car_id/public_praises" do
    it "lists all public praises" do
      get :index, car_id: aodi.id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/cars/:car_id/public_praises/sumup" do
    it "returns sumup of public praises" do
      allow(Megatron).to receive(:style_present?).and_return(true)
      get :sumup, car_id: aodi.id

      expect(response_json[:data][:id]).to be_present
    end

    it "returns 204 if the sytle is not present" do
      VCR.use_cassette("public_praises_style_blank") do
        aodi.update_columns(style_name: "abc")
        get :sumup, car_id: aodi.id

        expect(response.status).to eq 204
      end
    end

    it "return 202 if the job is processing" do
      allow(Megatron).to receive(:style_present?).and_return(true)
      service = PublicPraiseService.new(
        aodi.brand_name, aodi.series_name, aodi.style_name
      )
      RedisClient.current.set(service.mutex_key, 1)

      allow_any_instance_of(PublicPraiseService)
        .to receive(:execute).and_return(aodi_public_praise_sumup)

      get :sumup, car_id: aodi.id

      expect(response.status).to eq 202
    end
  end
end
