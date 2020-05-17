require "rails_helper"

RSpec.describe AntQueen::FetchService do
  fixtures :ant_queen_record_hubs, :ant_queen_records,
           :users, :maintenance_settings, :companies
  let(:nolan) { users(:nolan) }
  let(:record) { ant_queen_records(:ant_queen_record_uncheck) }
  let(:token) { Token.create(company_id: nolan.company_id, balance: 100000) }

  describe "#exec" do
    context "fetch" do
      context "exists success cache" do
        before do
          AntQueenRecordHub.update_all(result_status: "QUERY_SUCCESS")
          @brand_id = record.ant_queen_record_hub.car_brand_id
          @service = lambda do
            AntQueen::FetchService.new(
              record.vin,
              nolan,
              token,
              @brand_id
            ).execute
          end
        end

        it "attributes" do
          VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
            price = AntQueenRecord.unit_price(
              car_brand_id: @brand_id,
              company: nolan.company
            )
            @service.call
            my_record = AntQueenRecord.where(
              vin: record.vin,
              company_id: nolan.company_id,
              last_fetch_by: nolan.id
            ).last
            expect(my_record).to be_present
            expect(my_record.user_name).to eql nolan.name
            expect(my_record.state).to eql "unchecked"
            expect(my_record.token_price).to eql price
          end
        end

        it "generates ant_queen record" do
          VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
            price = AntQueenRecord.unit_price(
              car_brand_id: @brand_id,
              company: nolan.company
            )
            expect do
              @service.call
            end.to change { AntQueenRecord.count }.by(1).and\
              change { AntQueenRecordHub.count }.by(0).and\
                change { OperationRecord.count }.by(1).and\
                  change(MessageWorker.jobs, :size).by(1).and\
                    change { token.reload.balance }.by(-price).and\
                      change(MaintenanceTimeoutWorker.jobs, :size).by(1)
          end
        end

        context "hub is failed" do
          before do
            AntQueenRecordHub.update_all(result_status: "QUERY_FAIL")
          end

          it "creates record" do
            VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
              price = AntQueenRecord.unit_price(
                car_brand_id: @brand_id,
                company: nolan.company
              )
              expect do
                @service.call
              end.to change { AntQueenRecord.count }.by(1).and\
                change { AntQueenRecordHub.count }.by(1).and\
                  change { token.reload.balance }.by(-price)
            end
          end
        end
      end
    end

    context "not exists cache" do
      before do
        @vin = record.vin
        @brand_id = record.ant_queen_record_hub.car_brand_id
        AntQueenRecord.delete_all
        AntQueenRecordHub.where(vin: @vin).delete_all
        @service = lambda do
          AntQueen::FetchService.new(@vin, nolan, token, @brand_id).execute
        end
      end

      it "creates record" do
        VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
          price = AntQueenRecord.unit_price(
            car_brand_id: @brand_id,
            company: nolan.company
          )
          expect do
            @service.call
          end.to change { AntQueenRecord.count }.by(1).and\
            change { AntQueenRecordHub.count }.by(1).and\
              change { token.reload.balance }.by(-price)
        end
      end

      it "生成账单" do
        VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
          expect do
            @service.call
          end.to change { TokenBill.count }.by(1)
        end
      end

      it "state generating" do
        VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
          @service.call
          my_record = AntQueenRecord.where(vin: @vin, company: nolan.company_id).last
          expect(my_record.state).to eql "generating"
          expect(my_record.brand_name).to eql "奥迪"
        end
      end
    end
  end

  context "refetch" do
    before do
      @vin = record.vin
      @brand_id = record.ant_queen_record_hub.car_brand_id
      @service = lambda do
        AntQueen::FetchService.new(
          @vin, nolan, token,
          @brand_id,
          action: :refetch, record: record
        ).execute
      end
    end

    it "generates new hub" do
      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        price = AntQueenRecord.unit_price(
          car_brand_id: @brand_id,
          company: nolan.company
        )
        expect do
          @service.call
        end.to change { AntQueenRecordHub.count }.by(1).and\
          change { token.reload.balance }.by(-price).and\
            change(MaintenanceTimeoutWorker.jobs, :size).by(1)
      end
    end

    it "updates hub id" do
      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        hub = record.ant_queen_record_hub
        hub.update(result_status: "QUERY_SUCCESS")
        last_ant_queen_record_hub_id = hub.id
        @service.call
        new_hub = AntQueenRecordHub.last
        record.reload
        expect(record.ant_queen_record_hub_id).to eq new_hub.id
        expect(record.state).to eq "updating"
        expect(record.last_ant_queen_record_hub_id).to eq last_ant_queen_record_hub_id
      end
    end

    it "not updates hub id" do
      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        @service.call
        hub = AntQueenRecordHub.last
        record.reload
        expect(record.ant_queen_record_hub_id).to eq hub.id
        expect(record.state).to eq "updating"
        expect(record.last_ant_queen_record_hub_id).to eq nil
      end
    end

    context "handles exceptions" do
      it "raises AntQueen::Error::Buy" do
        VCR.use_cassette("ant_queen_buy_fail", allow_playback_repeats: true) do
          expect do
            @service.call
          end.to raise_error(AntQueen::Error::Buy).and\
            change { token.reload.balance }.by(0)
        end
      end
    end
  end
end
