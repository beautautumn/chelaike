require "rails_helper"

RSpec.describe Maintenance::FetchService do
  fixtures :maintenance_record_hubs, :maintenance_records, :users, :maintenance_settings
  let(:nolan) { users(:nolan) }
  let(:record) { maintenance_records(:maintenance_record_uncheck) }
  let(:token) { Token.create(company_id: nolan.company_id, balance: 100000) }

  describe "#exec" do
    context "fetch" do
      context "hub is failed" do
        before do
          @service = Maintenance::FetchService.new(record.vin, nolan, token)
        end

        it "decrement balance" do
          VCR.use_cassette("chejianding_buy_success") do
            expect do
              @service.execute
            end.to change { token.reload.balance }.by(-MaintenanceRecord.unit_price)
          end
        end

        it "creates hub" do
          VCR.use_cassette("chejianding_buy_success") do
            expect do
              @service.execute
            end.to change { MaintenanceRecordHub.count }.by(1)
          end
        end

        it "state generating" do
          VCR.use_cassette("chejianding_buy_success") do
            @service.execute
            my_record = MaintenanceRecord.where(vin: record.vin, company: nolan.company_id).last
            expect(my_record.state).to eql "generating"
          end
        end
      end

      context "exists cache" do
        before do
          MaintenanceRecordHub.update_all(notify_status: 2)
          @service = Maintenance::FetchService.new(record.vin, nolan, token)
        end

        it "generates maintenance record" do
          expect do
            @service.execute
          end.to change { MaintenanceRecord.count }.by(1)
        end

        it "fetchs from exsiting hub" do
          expect do
            @service.execute
          end.to change { MaintenanceRecordHub.count }.by(0)
        end

        it "creates OperationRecord" do
          expect do
            @service.execute
          end.to change { OperationRecord.count }.by(1).and\
            change(MessageWorker.jobs, :size).by(1)
        end

        it "decrement balance" do
          expect do
            @service.execute
          end.to change { token.reload.balance }.by(-MaintenanceRecord.unit_price)
        end

        it "generating record" do
          @service.execute
          my_record = MaintenanceRecord.where(vin: record.vin, company: nolan.company_id).last
          expect(my_record.last_fetch_by).to be nolan.id
          expect(my_record.user_name).to eql nolan.name
          expect(my_record.state).to eql "unchecked"
        end

        it "unchecked record" do
          MaintenanceRecordHub.update_all(notify_status: 2)
          @service.execute
          my_record = MaintenanceRecord.where(vin: record.vin, company: nolan.company_id).last
          expect(my_record.last_fetch_by).to be nolan.id
          expect(my_record.user_name).to eql nolan.name
          expect(my_record.state).to eql "unchecked"
        end

        it "fetchs from vendor while cache expried" do
          VCR.use_cassette("chejianding_buy_success") do
            stub_const("MaintenanceRecordHub::EXPERATION", 0)
            expect do
              @service.execute
            end.to change { MaintenanceRecordHub.count }.by(1)
          end
        end
      end

      context "not exists cache" do
        before do
          @vin = record.vin
          record.destroy
          MaintenanceRecordHub.where(vin: @vin).delete_all
        end

        let(:service) { Maintenance::FetchService.new(@vin, nolan, token) }

        it "creates record" do
          VCR.use_cassette("chejianding_buy_success") do
            expect do
              service.execute
            end.to change { MaintenanceRecord.count }.by(1)
          end
        end

        it "decrement balance" do
          VCR.use_cassette("chejianding_buy_success") do
            expect do
              service.execute
            end.to change { token.reload.balance }.by(-MaintenanceRecord.unit_price)
          end
        end

        it "creates hub" do
          VCR.use_cassette("chejianding_buy_success") do
            expect do
              service.execute
            end.to change { MaintenanceRecordHub.count }.by(1)
          end
        end

        it "state generating" do
          VCR.use_cassette("chejianding_buy_success") do
            service.execute
            my_record = MaintenanceRecord.where(vin: @vin, company: nolan.company_id).last
            expect(my_record.state).to eql "generating"
          end
        end
      end
    end

    context "handles exceptions" do
      let(:service) { Maintenance::FetchService.new(@vin, nolan, token) }
      it "raises CheJianDing BuyError" do
        VCR.use_cassette("chejianding_buy_fail") do
          expect { service.execute }.to raise_error(CheJianDing::BuyError)
        end
      end

      it "creates OperationRecord" do
        VCR.use_cassette("chejianding_buy_fail") do
          expect do
            service.execute
          end.to raise_error(CheJianDing::BuyError).and change { OperationRecord.count }.by(1)
        end
      end

      it "keeps balance" do
        VCR.use_cassette("chejianding_buy_fail") do
          expect do
            service.execute
          end.to raise_error(CheJianDing::BuyError).and change { token.reload.balance }.by(0)
        end
      end

      it "creates MessageJob" do
        VCR.use_cassette("chejianding_buy_fail") do
          expect do
            service.execute
          end.to raise_error(CheJianDing::BuyError).and change(MessageWorker.jobs, :size).by(1)
        end
      end
    end

    context "refetch" do
      before do
        @service = Maintenance::FetchService.new(record.vin, nolan, token,
                                                 action: :refetch, record: record)
        @vin = record.vin
      end

      it "generates new hub" do
        VCR.use_cassette("chejianding_buy_success") do
          expect do
            @service.execute
          end.to change { MaintenanceRecordHub.count }.by(1)
        end
      end

      it "decrement balance" do
        VCR.use_cassette("chejianding_buy_success") do
          expect do
            @service.execute
          end.to change { token.reload.balance }.by(-MaintenanceRecord.unit_price)
        end
      end

      it "updates hub id" do
        VCR.use_cassette("chejianding_buy_success") do
          hub = record.maintenance_record_hub
          hub.update(notify_status: 2)
          last_maintenance_record_hub_id = hub.id
          @service.execute
          new_hub = MaintenanceRecordHub.last
          record.reload
          expect(record.maintenance_record_hub_id).to eq new_hub.id
          expect(record.state).to eq "updating"
          expect(record.last_maintenance_record_hub_id).to eq last_maintenance_record_hub_id
        end
      end

      it "not updates hub id" do
        VCR.use_cassette("chejianding_buy_success") do
          @service.execute
          hub = MaintenanceRecordHub.last
          record.reload
          expect(record.maintenance_record_hub_id).to eq hub.id
          expect(record.state).to eq "updating"
          expect(record.last_maintenance_record_hub_id).to eq nil
        end
      end
    end
  end
end
