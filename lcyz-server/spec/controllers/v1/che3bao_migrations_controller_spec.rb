require "rails_helper"

RSpec.describe V1::Che3baoMigrationsController do
  # fixtures :companies

  # let(:tianche) { companies(:tianche) }

  # describe "POST /api/v1/che3bao_migrations" do
  #   it "can not execute if the comapny present" do
  #     allow(Che3bao::Corp).to receive(:find)
  #       .and_return(Che3bao::Corp.new(name: tianche.name))

  #     post :create, corp_id: 123
  #     expect(response.status).to eq 403
  #   end

  #   it "tells worker to migrate data" do
  #     allow(Che3bao::Corp).to receive(:find)
  #       .and_return(Che3bao::Corp.new(name: "abc"))

  #     expect(Che3baoMigrationsWorker).to receive(:perform_async).with("123")
  #     post :create, corp_id: 123
  #   end
  # end
end
