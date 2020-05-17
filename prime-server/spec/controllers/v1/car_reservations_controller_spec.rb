require "rails_helper"

RSpec.describe V1::CarReservationsController do
  fixtures(:all)

  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }
  let(:pingan) { insurance_companies(:pingan) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:nobita) { customers(:nobita) }
  let(:gian) { customers(:gian) }
  let(:doraemon) { customers(:doraemon) }
  let(:shizuka) { customers(:shizuka) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }

  before do
    login_user(zhangsan)
    give_authority(zhangsan, "在库车辆预定")
  end

  describe "POST /api/v1/cars/:car_id/car_reservation" do
    def request_lambda(customerize_create_params = {})
      parameter = ParamsBuilder.build(
        :car_reservations,
        zhangsan: zhangsan,
        aodi_4s: aodi_4s,
        pingan: pingan
      ).deep_symbolize_keys!.fetch(:create_parameters)

      auth_post(
        :create,
        car_id: aodi.id,
        car_reservation: parameter.merge(customerize_create_params)
      )
    end

    it "creates a reservation record" do
      request_lambda

      expect(aodi.car_reservation).to be_present
      expect(aodi.car_reservation.proxy_insurance).to be_present
      expect(aodi.reload.reserved_at).to eq Time.zone.parse("2015-04-30")
      expect(aodi.reserved).to be_truthy
      expect(aodi.sale_transfer.new_owner).to eq aodi.car_reservation.customer_name
      expect(zhangsan.customers.find_by(phone: "110")).to be_present
    end

    it "关联没有意向的客户，并预定成功" do
      customerize_create_params = { customer_phone: nobita.phone }
      request_lambda(customerize_create_params)

      intention = nobita.intentions.first

      expect(aodi.car_reservation).to be_present
      expect(aodi.car_reservation.customer.phone).to eq nobita.phone
      expect(intention.state).to eq "reserved"
      expect(nobita.intentions.first.channel_id).to eq aodi_4s.id
    end

    it "关联有已完成意向的客户，并预定成功" do
      give_authority(zhangsan, "代办客户预定/出库")

      customerize_create_params = { customer_phone: gian.phone }
      request_lambda(customerize_create_params)

      intention = Intention.find_by(customer_id: aodi.car_reservation.customer.id)
      expect(aodi.car_reservation).to be_present
      expect(intention.state).not_to eq "reserved"
    end

    it "关联有未完成意向的客户，并预定成功" do
      shizuka.intentions.find_by(intention_type: "seek").update_columns(assignee_id: zhangsan.id)

      customerize_create_params = { customer_phone: shizuka.phone }
      request_lambda(customerize_create_params)

      intention = Intention.find_by(customer_id: aodi.car_reservation.customer.id)

      expect(aodi.car_reservation).to be_present
      expect(intention.state).to eq "reserved"
    end

    it_should_behave_like "operation_record created" do
      let(:request_query) { request_lambda }
    end
  end

  describe "PUT /api/v1/cars/:car_id/car_reservation" do
    before do
      reservation_params = ParamsBuilder.build(
        :car_reservations,
        zhangsan: zhangsan,
        aodi_4s: aodi_4s,
        pingan: pingan).deep_symbolize_keys!.fetch(:create_parameters)
      auth_post :create, car_id: aodi.id, car_reservation: reservation_params
    end

    def update_params
      parameter = ParamsBuilder.build(
        :car_reservations,
        zhangsan: zhangsan,
        aodi_4s: aodi_4s,
        pingan: pingan
      ).deep_symbolize_keys!.fetch(:create_parameters)

      parameter[:deposit_wan] = 11
      parameter[:closing_cost_wan] = 23
      parameter[:commercial_insurance_fee_yuan] = 500
      parameter
    end

    it "updates the reservation infomation" do
      car_reservation = aodi.car_reservation
      auth_put :update, car_id: aodi.id, car_reservation: update_params

      car_reservation.reload
      expect(car_reservation.deposit_wan).to eq 11
      expect(car_reservation.closing_cost_wan).to eq 23
      expect(car_reservation.commercial_insurance_fee_yuan).to eq 500
    end
  end

  describe "GET /api/v1/cars/:car_id" do
    it "获取预定信息" do
      auth_get :show, car_id: aodi.id

      expect(response_json[:data][:reserved_at]).to be_present
    end
  end

  describe "PUT /api/v1/cars/:car_id/car_reservation/cancel" do
    context "cancel reservation" do
      before do
        travel_to Time.zone.now
        aodi.update_columns(reserved_at: Time.zone.parse("2015-01-01"), reserved: true)

        @request_lambda = lambda do
          auth_put :cancel, car_id: aodi.id,
                            cancel_reservation: {
                              cancelable_price_wan: 100,
                              note: "我来退定了",
                              canceled_at: "2015-01-10"
                            }
        end
      end

      after do
        expect(aodi.reload.reserved_at).to be_nil
        expect(aodi.reload.reserved).to be_falsy
        expect(aodi.car_cancel_reservation.cancelable_price_wan).to eq 100
        expect(aodi.car_reservation).to be_nil
      end

      it "makes car available" do
        @request_lambda.call

        expect(aodi.car_cancel_reservation.canceled_at)
          .to eq Time.zone.parse("2015-01-10")
      end

      it "sets Time.now to canceled_at when params without canceled_at" do
        auth_put :cancel, car_id: aodi.id,
                          cancel_reservation: {
                            cancelable_price_wan: 100,
                            note: "我来退定了"
                          }

        expect(aodi.car_cancel_reservation.canceled_at).to eq Time.zone.now
      end

      it "关联意向改为取消预定状态" do
        aodi.car_reservation.update_columns(customer_id: doraemon.id)

        @request_lambda.call

        expect(doraemon_seeking_aodi.reload.state).to eq "cancel_reserved"
      end

      it_should_behave_like "operation_record created" do
        let(:request_query) { @request_lambda.call }
      end
    end

    context "car has no reservation" do
      it "returns normal data" do
        aodi.update_columns(reserved: false)
        aodi.car_reservation.destroy

        auth_put :cancel, car_id: aodi.id,
                          cancel_reservation: {
                            cancelable_price_wan: 100,
                            note: "我来退定了",
                            canceled_at: "2015-01-10"
                          }

        expect(aodi.reload.reserved).to be_falsy
        expect(response.status).to eq 403
      end
    end
  end
end
