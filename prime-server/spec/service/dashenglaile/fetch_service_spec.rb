require "rails_helper"

RSpec.describe Dashenglaile::FetchService do
  fixtures :dashenglaile_record_hubs, :dashenglaile_records,
           :users, :maintenance_settings, :companies, :platform_brands
  let(:lisi) { users(:lisi) }
  let(:xiaocheche) { users(:xiaocheche) }
  let(:record) { dashenglaile_records(:dashenglaile_record_uncheck) }
  let(:token) { Token.create(company_id: lisi.company_id, balance: 100000) }

  describe "#exec" do
    context "submit with image and fetch by dashboard" do
      before do
        @vin_image = "http://image.chelaike.com/images/d111bfe9-980f-4a95-95f0-676803323fa1.jpg"
        @submit_service = lambda do
          Dashenglaile::FetchService.new(
            @vin_image,
            lisi,
            token,
            is_image: true,
            brand_id: 19
          ).execute
        end
      end

      it "generates record with vin image" do
        VCR.use_cassette("dasheng_submit_image", allow_playback_repeats: true) do
          price = DashenglaileRecord.unit_price(
            car_brand_id: 19,
            company: lisi.company
          )
          expect do
            @submit_service.call
          end.to change { DashenglaileRecord.count }.by(1).and\
            change { DashenglaileRecordHub.count }.by(1).and\
              change { token.reload.balance }.by(-price)

          submitted_record = DashenglaileRecord.where(
            vin_image: @vin_image,
            company_id: lisi.company_id,
            last_fetch_by: lisi.id
          ).last

          expect(submitted_record).to be_present
          expect(submitted_record.state).to eq "submitted"
          expect(submitted_record.vin_image).to eq @vin_image
        end
      end

      it "fail to make vin" do
        VCR.use_cassette("dasheng_submit_image_fail", allow_playback_repeats: true) do
          price = DashenglaileRecord.unit_price(
            car_brand_id: 11,
            company: lisi.company
          )

          @submit_service.call

          submitted_record = DashenglaileRecord.where(
            vin_image: @vin_image,
            company_id: lisi.company_id,
            last_fetch_by: lisi.id
          ).last

          expect do
            Dashenglaile::FetchService.new("WUAANB428CN002389", nil, token)
                                      .fire(submitted_record, true, "图片不清晰")
          end.to change {
            OperationRecord.where(operation_record_type: :vin_image_fail).count
          }.by(1).and\
            change { token.reload.balance }.by(price)

          message = OperationRecord.where(operation_record_type: :vin_image_fail).last
          expect(message.message_text).to be_present
          expect(submitted_record).to be_present
          expect(submitted_record.state).to eq "vin_image_fail"
        end
      end

      it "deal with image record" do
        VCR.use_cassette("dasheng_query_image", allow_playback_repeats: true) do
          @submit_service.call
          submitted_record = DashenglaileRecord.where(
            vin_image: @vin_image,
            company_id: lisi.company_id,
            last_fetch_by: lisi.id
          ).last

          # 写入 VIN，关联 record
          Dashenglaile::FetchService.new("WUAANB428CN002389", nil, token).fire(submitted_record)

          expect(submitted_record.reload.state).to eq "generating"
          expect(submitted_record.reload.vin).to eq "WUAANB428CN002389"
        end
      end
    end

    context "fetch" do
      context "exists success cache" do
        before do
          DashenglaileRecordHub.update_all(result_status: "QUERY_SUCCESS")
          @brand_id = record.dashenglaile_record_hub.car_brand_id
          @service = lambda do
            Dashenglaile::FetchService.new(
              record.vin,
              lisi,
              token
            ).execute
          end
        end

        it "attributes" do
          VCR.use_cassette("dashenglaile_buy_success_1", allow_playback_repeats: true) do
            price = DashenglaileRecord.unit_price(
              car_brand_id: @brand_id,
              company: lisi.company
            )
            expect { @service.call }.to change { TokenBill.count }.by(1)
            my_record = DashenglaileRecord.where(
              vin: record.vin,
              company_id: lisi.company_id,
              last_fetch_by: lisi.id
            ).last
            expect(my_record).to be_present
            expect(my_record.user_name).to eql lisi.name
            expect(my_record.state).to eql "unchecked"
            expect(my_record.token_price).to eql price
          end
        end

        it "generates dashenglaile record" do
          VCR.use_cassette("dashenglaile_buy_success_2", allow_playback_repeats: true) do
            price = DashenglaileRecord.unit_price(
              car_brand_id: @brand_id,
              company: lisi.company
            )
            expect do
              @service.call
            end.to change { DashenglaileRecord.count }.by(1).and\
              change { DashenglaileRecordHub.count }.by(0).and\
                change { OperationRecord.count }.by(1).and\
                  change(MessageWorker.jobs, :size).by(1).and\
                    change { token.reload.balance }.by(-price).and\
                      change(MaintenanceTimeoutWorker.jobs, :size).by(1).and\
                        change { TokenBill.count }.by(1)
          end
        end

        context "hub is failed" do
          before do
            DashenglaileRecordHub.update_all(result_status: "QUERY_FAIL")
          end

          it "creates record" do
            VCR.use_cassette("dasheng_buy_success_3", allow_playback_repeats: true) do
              price = DashenglaileRecord.unit_price(
                car_brand_id: @brand_id,
                company: lisi.company
              )
              expect do
                @service.call
              end.to change { DashenglaileRecord.count }.by(1).and\
                change { DashenglaileRecordHub.count }.by(1).and\
                  change { token.reload.balance }.by(-price).and\
                    change { TokenBill.count }.by(1)
            end
          end
        end
      end

      context "not exists cache" do
        before do
          @vin = record.vin
          @brand_id = record.dashenglaile_record_hub.car_brand_id
          DashenglaileRecord.delete_all
          DashenglaileRecordHub.where(vin: @vin).delete_all
          @service = lambda do
            Dashenglaile::FetchService.new(@vin, lisi, token).execute
          end
        end

        it "creates record" do
          VCR.use_cassette("dasheng_buy_success_3", allow_playback_repeats: true) do
            price = DashenglaileRecord.unit_price(
              car_brand_id: @brand_id,
              company: lisi.company
            )
            expect do
              @service.call
            end.to change { DashenglaileRecord.count }.by(1).and\
              change { DashenglaileRecordHub.count }.by(1).and\
                change { token.reload.balance }.by(-price).and\
                  change { TokenBill.count }.by(1)
          end
        end

        it "state generating" do
          VCR.use_cassette("dasheng_buy_success_4", allow_playback_repeats: true) do
            _ = DashenglaileRecord.unit_price(
              car_brand_id: @brand_id,
              company: lisi.company
            )
            @service.call
            my_record = DashenglaileRecord.where(vin: @vin, company: lisi.company_id).last
            expect(my_record.state).to eql "generating"
            # expect(my_record.brand_name).to eql "奥迪"
          end
        end
      end

      context "brand is deleted by idoits" do
        before do
          @vin = "LVHRM1848E5060670"
          @brand_id = 16
          @service = lambda do
            Dashenglaile::FetchService.new(@vin, lisi, token).execute
          end
        end

        it "creates record" do
          VCR.use_cassette("dasheng_query_nil_brand", allow_playback_repeats: true) do
            price = DashenglaileRecord.unit_price(
              car_brand_id: @brand_id,
              company: lisi.company
            )
            expect do
              @service.call
            end.to change { DashenglaileRecord.count }.by(1).and\
              change { DashenglaileRecordHub.count }.by(1).and\
                change { token.reload.balance }.by(-price).and\
                  change { TokenBill.count }.by(1)
          end
        end
      end
    end
  end

  context "refetch" do
    before do
      @vin = record.vin
      @brand_id = record.dashenglaile_record_hub.car_brand_id
      @service = lambda do
        Dashenglaile::FetchService.new(
          @vin, lisi, token,
          action: :refetch, record: record
        ).execute
      end
    end

    it "generates new hub" do
      VCR.use_cassette("dasheng_refetch_success", allow_playback_repeats: true) do
        price = DashenglaileRecord.unit_price(
          car_brand_id: @brand_id,
          company: lisi.company
        )
        expect do
          @service.call
        end.to change { DashenglaileRecordHub.count }.by(1).and\
          change { token.reload.balance }.by(-price).and\
            change(MaintenanceTimeoutWorker.jobs, :size).by(1).and\
              change { TokenBill.count }.by(1)
      end
    end

    it "updates hub id" do
      VCR.use_cassette("dasheng_refetch_success", allow_playback_repeats: true) do
        _ = DashenglaileRecord.unit_price(
          car_brand_id: @brand_id,
          company: lisi.company
        )
        hub = record.dashenglaile_record_hub
        hub.update(result_status: "QUERY_SUCCESS")
        last_dashenglaile_record_hub_id = hub.id
        @service.call
        new_hub = DashenglaileRecordHub.last
        record.reload
        expect(record.dashenglaile_record_hub_id).to eq new_hub.id
        expect(record.state).to eq "updating"
        expect(record.last_dashenglaile_record_hub_id).to eq last_dashenglaile_record_hub_id
      end
    end

    it "not updates hub id" do
      VCR.use_cassette("dasheng_refetch_success", allow_playback_repeats: true) do
        _ = DashenglaileRecord.unit_price(
          car_brand_id: @brand_id,
          company: lisi.company
        )
        @service.call
        hub = DashenglaileRecordHub.last
        record.reload
        expect(record.dashenglaile_record_hub_id).to eq hub.id
        expect(record.state).to eq "updating"
        expect(record.last_dashenglaile_record_hub_id).to eq nil
      end
    end

    context "handles exceptions" do
      it "raises Dashenglaile::Error::Buy" do
        VCR.use_cassette("dasheng_buy_fail", allow_playback_repeats: true) do
          expect do
            @service.call
          end.to raise_error(Dashenglaile::Error::Buy).and\
            change { token.reload.balance }.by(0)
        end
      end
    end
  end
end
