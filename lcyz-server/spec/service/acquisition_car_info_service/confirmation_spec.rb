require "rails_helper"

RSpec.describe AcquisitionCarInfoService::Confirmation do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:disney) { shops(:disney) }
  let(:pixar) { shops(:pixar) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:aodi) { cars(:aodi) }
  let(:acquisition_aodi) { acquisition_car_infos(:aodi) }
  let(:avengers) { alliances(:avengers) }

  def confirmation_params
    {
      acquisition_price_wan: 10,
      acquired_at: Date.new(2016, 7, 28),
      company_id: tianche.id,
      shop_id: disney.id
    }
  end

  describe "#create" do
    context "没有选择联盟" do
      it "创建一个‘确认收购’清单" do
        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)
        expect do
          service.create(confirmation_params).confirmation
        end.to change { AcquisitionConfirmation.count }.by(1)
      end

      it "入库商家,店铺只能是信息发布人所在商家" do
        params = confirmation_params.merge(company_id: nil, shop_id: nil)

        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)
        confirmation = service.create(params).confirmation
        expect(confirmation.company).to eq tianche
        expect(confirmation.shop).to eq disney
      end

      it "本商家根据收车信息创建一个入库车辆" do
        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)
        expect do
          service.create(confirmation_params)
        end.to change { tianche.cars.in_hall.count }.by(1)
      end

      it "入库车辆跟这个收车绑定" do
        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)
        car = service.create(confirmation_params).car
        expect(acquisition_aodi.reload.car).to eq car
      end

      it "更新这个收车信息的状态为 finished" do
        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)
        service.create(confirmation_params)
        expect(acquisition_aodi.reload.state).to eq "finished"
      end
    end

    context "选择联盟" do
      before do
        @params = confirmation_params.merge(
          alliance_id: avengers.id,
          cooperate_companies: [warner.id],
          company_id: warner.id,
          shop_id: pixar.id
        )
      end

      it "记录选择的联盟及合作商家" do
        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)
        result = service.create(@params)
        confirmation = result.confirmation

        expect(confirmation.alliance).to eq avengers
        expect(confirmation.cooperate_companies).to match_array [warner.id]
      end

      it "记录指定的商家及店铺" do
        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)
        result = service.create(@params)

        confirmation = result.confirmation
        expect(confirmation.company).to eq warner
        expect(confirmation.shop).to eq pixar
      end

      it "车辆入库到指定的商家及店铺" do
        service = AcquisitionCarInfoService::Confirmation.new(zhangsan, acquisition_aodi)

        expect do
          service.create(@params)
        end.to change { warner.cars.in_hall.count }.by(1)
      end
    end
  end
end
