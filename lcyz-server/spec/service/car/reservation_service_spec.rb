require "rails_helper"

RSpec.describe Car::ReservationService do
  fixtures(:all)

  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:pingan) { insurance_companies(:pingan) }
  let(:nobita) { customers(:nobita) }
  let(:gian) { customers(:gian) }
  let(:doraemon) { customers(:doraemon) }
  let(:shizuka) { customers(:shizuka) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }

  let(:create_reservation_params) do
    ParamsBuilder.build(
      :car_reservations,
      zhangsan: zhangsan,
      aodi_4s: aodi_4s,
      pingan: pingan
    ).deep_symbolize_keys!.fetch(:create_parameters)
  end

  def mock_checkservice_result(result = nil)
    allow_any_instance_of(Intention::CheckService).to receive_messages(check!: result)
  end

  def create_result
    Car::ReservationService.new(zhangsan, aodi, create_reservation_params).create(zhangsan)
  end

  describe "#create" do
    context "checks agency passed" do
      it "creates a new car_reservation for the car" do
        mock_checkservice_result

        result = create_result
        car_reservation = result.car_reservation

        expect(result.valid?).to be_truthy
        expect(aodi.reserved).to be_truthy
        expect(CarReservation.last).to eq car_reservation
        expect(car_reservation.current).to be_truthy
      end

      it "fails to create a new car_reservation if car is reserved" do
        CarReservation.destroy_all

        mock_checkservice_result
        aodi.update reserved: true
        result = create_result

        expect(result.valid?).to be_falsey
        expect(CarReservation.count).to eq 0
      end
    end

    context "checks agency failed" do
      it "returns forbidden_error message" do
        CarReservation.destroy_all
        allow_any_instance_of(Intention::CheckService).to receive(:check!) do
          raise Intention::CheckService::InvalidError, "some error"
        end

        expect do
          create_result
        end.to raise_error(Intention::CheckService::InvalidError, "some error")
        expect(CarReservation.count).to eq 0
      end
    end
  end

  describe "#update!(operator)" do
    def car_reservation
      create_result
      aodi.car_reservation
    end

    def update_result
      update_params = create_reservation_params.merge(
        deposit_wan: 11,
        closing_cost_wan: 23,
        customer_phone: "1234",
        customer_name: "peter"
      )
      Car::ReservationService.new(zhangsan, aodi, update_params)
                             .update!(zhangsan)
    end

    context "checks agency passed" do
      before do
        mock_checkservice_result
      end

      it "updates the last car_reservation for the car" do
        reservation = car_reservation

        result = update_result

        reservation.reload
        expect(result.valid?).to be_truthy
        expect(aodi.reserved).to be_truthy
        expect(reservation.deposit_wan).to eq 11
        expect(reservation.closing_cost_wan).to eq 23
        expect(reservation.customer_name).to eq "peter"
        expect(reservation.customer_phone).to eq "1234"
      end

      it "fails to update the car_reservation if the car is not reserved" do
        reservation = car_reservation
        aodi.update_columns(reserved: false)

        update_params = create_reservation_params.merge(deposit_wan: 11, closing_cost_wan: 23)
        result = Car::ReservationService.new(zhangsan, aodi, update_params)
                                        .update!(zhangsan)

        reservation.reload
        expect(result.valid?).to be_falsey
        expect(reservation.deposit_wan).to eq 5
        expect(reservation.closing_cost_wan).to eq 20
      end

      it "fails if the reservation is not the current one" do
        reservation = car_reservation
        reservation.update_columns(current: false)

        update_params = create_reservation_params.merge(deposit_wan: 11, closing_cost_wan: 23)
        result = Car::ReservationService.new(zhangsan, aodi, update_params)
                                        .update!(zhangsan)
        reservation.reload
        expect(result.valid?).to be_falsey
      end

      it "does not create a new customer" do
        reservation = car_reservation

        customer_count = zhangsan.customers.count
        update_params = create_reservation_params.merge(deposit_wan: 11, closing_cost_wan: 23)
        Car::ReservationService.new(zhangsan, aodi, update_params)
                               .update!(zhangsan)

        reservation.reload
        expect(zhangsan.reload.customers.count).to eq customer_count
      end
    end

    context "checks agency failed" do
      it "returns forbidden_error message" do
        allow_any_instance_of(Intention::CheckService).to receive(:check!) do
          raise Intention::CheckService::InvalidError, "some error"
        end

        expect do
          update_result
        end.to raise_error(Intention::CheckService::InvalidError, "some error")
        expect(CarReservation.count).to eq 1
      end
    end
  end

  describe "#cancel" do
    before do
      travel_to Time.zone.now
      aodi.update_columns(reserved_at: Time.zone.parse("2015-01-01"), reserved: true)
    end

    let(:car_cancel_reservation_params) do
      {
        cancelable_price_wan: 100,
        note: "我来退定了",
        canceled_at: "2015-01-10"
      }
    end

    def service_result
      Car::ReservationService.new(zhangsan, aodi, car_cancel_reservation_params).cancel
    end

    context "cancel success" do
      it "returns expected data" do
        result = service_result
        expect(result.valid?).to be_truthy
      end

      it "updates the car's reserved to false" do
        service_result
        expect(aodi.reload.reserved).to be_falsey
      end

      it "creates a new car_cancel_reservation for the car" do
        service_result
        expect(aodi.car_cancel_reservations.count).to eq 1
      end

      context "operates associations" do
        before do
          allow_any_instance_of(Intention::CheckService).to receive_messages(check!: nil)
          Car::ReservationService.new(zhangsan, aodi, create_reservation_params).create(zhangsan)
        end

        it "makes all reservations to histories" do
          car_reservation = aodi.car_reservation
          service_result
          expect(car_reservation.reload.current).to be_falsey
        end

        it "creates an operation record" do
          OperationRecord.destroy_all
          service_result
          expect(aodi.operation_records.count).to eq 1
        end
      end
    end

    context "the car has no reservation" do
      before do
        aodi.update_columns(reserved: false)
        aodi.car_reservation.destroy
      end

      it "keeps the reservation state as false" do
        expect do
          Car::ReservationService.new(zhangsan, aodi.reload, car_cancel_reservation_params).cancel
        end.to raise_error(Car::ReservationService::NoReservationError, "车辆未被预定")
      end
    end
  end
end
