require "rails_helper"

if ENV.key?("LOCAL_TEST")
  RSpec.describe CheJianDing do
    before do
      WebMock.allow_net_connect!
      VCR.turn_off!
    end

    let(:invalid_vin) { "LSVAU033972103735" }
    let(:valid_vin) { "LHGRB186072026733" }

    describe ".ping" do
      it "returns 200" do
        response = CheJianDing.ping
        expect(response.code).to eq 200
      end
    end

    describe ".account_info" do
      it "returns success status" do
        response = CheJianDing.account_info

        expect(response["info"]["status"]).to eq "1"
      end
    end

    describe "verify rsa sign" do
      it "returns true" do
        data = "asdfasdfjalfja"
        signature = CheJianDing.send(:sign, data)
        verify = CheJianDing.send(:verify, signature, data)

        expect(verify).to be_truthy
      end
    end

    describe ".process" do
      it "raise error when invalid vin" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_buy_fail") do
          expect do
            CheJianDing.process(vin: invalid_vin,
                                license_plate: "鲁LD8888",
                                engine: "246764K",
                                mobile: "15157126128",
                                order_no: Time.now.to_i)
          end.to raise_error(CheJianDing::BuyError)
        end
      end
    end

    describe ".buy" do
      it "returns no success status with invalid vin" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_buy_fail") do
          response = CheJianDing.buy(vin: invalid_vin,
                                     license_plate: "鲁LD8888",
                                     engine: "246764K",
                                     mobile: "15157126128",
                                     order_no: Time.now.to_i)

          expect(response["info"]["status"]).to eq "4"
        end
      end

      it "returns success status with valid vin" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_buy_success") do
          response = CheJianDing.buy(vin: valid_vin,
                                     license_plate: "鲁LD8888",
                                     engine: "246764K",
                                     mobile: "15157126128",
                                     order_no: Time.now.to_i)

          expect(response["info"]["status"]).to eq "1"
        end
      end
    end

    describe ".order_info" do
      it "returns no success status with invalid order_id" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_order_info_fail") do
          response = CheJianDing.order_info("111111111")

          expect(response["info"]["status"]).to eq "3"
        end
      end

      it "returns success status with valid order_id" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_buy_success") do
          response = CheJianDing.buy(vin: valid_vin,
                                     license_plate: "鲁LD8888",
                                     engine: "246764K",
                                     mobile: "15157126128",
                                     order_no: Time.now.to_i)

          expect(response["info"]["status"]).to eq "1"
          expect(response["info"]["orderId"]).not_to be_nil
        end
        VCR.use_cassette("chejianding_order_info_success") do
          response = CheJianDing.order_info(@order_id)
          expect(response["info"]["status"]).to eq "1"
          expect(response["info"]["orderStatus"]).to eq "3"
        end
      end
    end

    describe ".check_brand" do
      it "returns no success status with invalid order_id" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_check_brand_fail") do
          response = CheJianDing.check_brand(invalid_vin)

          expect(response["info"]["status"]).to eq "1"
          expect(response["info"]["brandStatus"]).to eq "3"
        end
      end

      it "returns success status with valid vin" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_check_brand_success") do
          response = CheJianDing.check_brand("LHGRB186072026733")

          expect(response["info"]["status"]).to eq "1"
          expect(response["info"]["brandStatus"]).to eq "2"
        end
      end
    end

    describe ".parse_and_persisted" do
      let(:order_id) { "2168a29025a84d949c38b4c7e8b6232f" }
      let(:vin) { "LVGDA46A59G008778" }

      before do
        hub = MaintenanceRecordHub.create(order_id: order_id)
        @record = MaintenanceRecord.create(vin: vin,
                                           state: :generating,
                                           maintenance_record_hub_id: hub.id)
      end

      it "returns hub record" do
        VCR.turn_on!
        VCR.use_cassette("chejianding_parse_and_persistent_html") do
          hub = CheJianDing.parse_and_persisted(order_id)

          expect(hub.persisted?).to be_truthy
          expect(hub.vin).to eq vin
          expect(hub.transmission).to eq "auto"
          expect(hub.displacement).to eq "2.7L"

          items = hub.items

          expect(items.size).to eq 18
          expect(items.last["date"]).to eq "2016-03-04"
          expect(items.last["category"]).to eq "定期保养"
          expect(items.last["item"]).to eq "项目：245K保养；"
          expect(items.last["material"])
            .to eq "材料：全合成机油-5W/20(4L)；全合成机油-5W/20(1L)；机油滤清器滤芯组件；密封垫片；"
        end
      end
    end

    describe ".parse_and_persisted_json(hub, data_hash)" do
      let(:order_id) { "2168a29025a84d949c38b4c7e8b6232f" }
      let(:vin) { "LVGDA46A59G008778" }
      let(:data_json) do
        <<-JSON
        { "resume": { "sd": "0", "ab": "0", "mi": "0", "ronum": "20", "mile": "90016", "tr": "0", "en": "1", "wgjdesc": "前保险杠喷漆;", "lastdate": "2016-09-25" }, "info": { "status": "5", "message": "报告查询成功" }, "reportJson": [ { "content": "进行带附加组件的 A 类保养范围；&nbsp;", "material": "机滤；&nbsp;机油；&nbsp;", "mileage": "9956", "repairDate": "2014-10-01", "type": "保养" }, { "content": "自定义工时；&nbsp;空调系统清洗 与消毒及车内杀菌除臭；&nbsp;【54602601】；&nbsp;", "material": "", "mileage": "20742", "repairDate": "2015-06-16", "type": "其他工作" }, { "content": "进行带附加组件的 B 类保养范围；&nbsp;进行保养的附加工作， 更换空气滤清器滤芯；&nbsp;自定义工时；&nbsp;", "material": "机滤；&nbsp;0W40机油；&nbsp;空气滤芯；&nbsp;空调滤芯；&nbsp;", "mileage": "20742", "repairDate": "2015-06-16", "type": "保养" }, { "content": "进行带附加组件的 A 类保养范围；&nbsp;自定义工时；&nbsp;", "material": "机滤；&nbsp;金美孚机油；&nbsp;", "mileage": "30458", "repairDate": "2015-08-05", "type": "索赔工作" }, { "content": "检查恒温控制系统 （快速检测后）；&nbsp;自定义工时；&nbsp;拆卸/安装手套箱 INSTALL；&nbsp;更换新鲜空气/空气内循环风门 的促动马达 （检测后）；&nbsp;检查....................的线束 （快速检测后）；&nbsp;检查空调的制冷功率；&nbsp;", "material": "", "mileage": "30458", "repairDate": "2015-08-05", "type": "保养" }, { "content": "自定义工时；&nbsp;检查电气设备， 确定诊断结果；&nbsp;检查起动马达；&nbsp;拆卸/安装起动马达；&nbsp;", "material": "", "mileage": "32374", "repairDate": "2015-09-01", "type": "一般修理" }, { "content": "自定义工时；&nbsp;拆卸/安装起动马达；&nbsp;", "material": "【MA001 152 82 10】；&nbsp;保险丝20A；&nbsp;", "mileage": "35715", "repairDate": "2015-10-19", "type": "索赔工作" }, { "content": "检查起动马达；&nbsp;", "material": "", "mileage": "35715", "repairDate": "2015-10-19", "type": "索赔工作" } ], "basic": { "vin": "LE4GG8BB3EL315687", "model": "奔驰GLK", "year": "", "brand": "北京奔驰", "displacement": "3.0L", "gearbox": "A/MT" } }
        JSON
      end

      it "正常解析hash参数" do
        hub = MaintenanceRecordHub.create(order_id: order_id)
        data_hash = MultiJson.load(data_json)
        CheJianDing.parse_and_persisted_json(hub, data_hash)
        expect(hub.reload.abstract_items).to be_present
      end

      it "更新hub记录" do
        hub = MaintenanceRecordHub.create(order_id: order_id)
        data_hash = MultiJson.load(data_json)
        CheJianDing.parse_and_persisted_json(hub, data_hash)
        expect(hub.reload.abstract_items).to be_present
        expect(hub.reload.items.count).to be > 0
      end
    end
  end
end
