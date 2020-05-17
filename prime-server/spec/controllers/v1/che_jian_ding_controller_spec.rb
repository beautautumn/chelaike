require "rails_helper"

RSpec.describe V1::CheJianDingController do
  fixtures :maintenance_record_hubs, :maintenance_records, :tokens

  let(:hub_a) { maintenance_record_hubs(:maintenance_record_hub_a) }
  let(:data_json) do
    <<-JSON
    { "resume": { "sd": "0", "ab": "0", "mi": "0", "ronum": "20", "mile": "90016", "tr": "0", "en": "1", "wgjdesc": "前保险杠喷漆;", "lastdate": "2016-09-25" }, "info": { "status": "5", "message": "报告查询成功" }, "reportJson": [ { "content": "进行带附加组件的 A 类保养范围；&nbsp;", "material": "机滤；&nbsp;机油；&nbsp;", "mileage": "9956", "repairDate": "2014-10-01", "type": "保养" }, { "content": "自定义工时；&nbsp;空调系统清洗 与消毒及车内杀菌除臭；&nbsp;【54602601】；&nbsp;", "material": "", "mileage": "20742", "repairDate": "2015-06-16", "type": "其他工作" }, { "content": "进行带附加组件的 B 类保养范围；&nbsp;进行保养的附加工作， 更换空气滤清器滤芯；&nbsp;自定义工时；&nbsp;", "material": "机滤；&nbsp;0W40机油；&nbsp;空气滤芯；&nbsp;空调滤芯；&nbsp;", "mileage": "20742", "repairDate": "2015-06-16", "type": "保养" }, { "content": "进行带附加组件的 A 类保养范围；&nbsp;自定义工时；&nbsp;", "material": "机滤；&nbsp;金美孚机油；&nbsp;", "mileage": "30458", "repairDate": "2015-08-05", "type": "索赔工作" }, { "content": "检查恒温控制系统 （快速检测后）；&nbsp;自定义工时；&nbsp;拆卸/安装手套箱 INSTALL；&nbsp;更换新鲜空气/空气内循环风门 的促动马达 （检测后）；&nbsp;检查....................的线束 （快速检测后）；&nbsp;检查空调的制冷功率；&nbsp;", "material": "", "mileage": "30458", "repairDate": "2015-08-05", "type": "保养" }, { "content": "自定义工时；&nbsp;检查电气设备， 确定诊断结果；&nbsp;检查起动马达；&nbsp;拆卸/安装起动马达；&nbsp;", "material": "", "mileage": "32374", "repairDate": "2015-09-01", "type": "一般修理" }, { "content": "自定义工时；&nbsp;拆卸/安装起动马达；&nbsp;", "material": "【MA001 152 82 10】；&nbsp;保险丝20A；&nbsp;", "mileage": "35715", "repairDate": "2015-10-19", "type": "索赔工作" }, { "content": "检查起动马达；&nbsp;", "material": "", "mileage": "35715", "repairDate": "2015-10-19", "type": "索赔工作" } ], "basic": { "vin": "LE4GG8BB3EL315687", "model": "奔驰GLK", "year": "", "brand": "北京奔驰", "displacement": "3.0L", "gearbox": "A/MT" } }
    JSON
  end

  let(:company_token) { tokens(:company_token) }
  let(:user_token) { tokens(:user_token) }

  describe "#notify" do
    context "not pass verify signature" do
      before do
        allow_any_instance_of(OpenSSL::PKey::RSA).to receive(:verify).and_return(false)
      end

      it "returns status 0" do
        post :notify, orderId: "orderId",
                      vin: "vin",
                      orderStatus: "1",
                      time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                      sign: "sign"

        expect(response.status).to eq 200
        expect(response_json[:info][:status]).to eq 0
      end
    end

    context "verify signature" do
      before do
        allow(CheJianDing).to receive(:pwd).and_return("51423f12628ec2abcd3c51810f4f79ef")
      end

      let(:params) do
        { "sign" => "XSu7hirFtMGCU2uEbIFxMdXW9ALHsJLRtsVJxs6KI3leLrX" \
                    "NQGQ3gFY5r3MLHeSXcSlK/cbcaQCTPiItqzwSolxcNWrj4xNup" \
                    "+fCNytFd0yz8np/e524fIVvUjCvYuh7obD+oU3JMjce9APuZ3s75F" \
                    "LOawvygdLzAIoCj1p8VHo=",
          "time" => "Fri, 17 Jun 2016 11:34:40 +0000",
          "orderFlag" => "6",
          "vin" => "LFPH4ACC9A1E37836",
          "reportId" => "3423c727c3cb48978fa0a453494e58f7",
          "orderStatus" => 6,
          "orderId" => "3423c727c3cb48978fa0a453494e58f7",
          "dataJson" => data_json,
          "controller" => "v1/che_jian_ding",
          "action" => "notify" }
      end

      it "returns status 0" do
        post :notify, params

        expect(response.status).to eq 200
        expect(response_json[:info][:status]).to eq 0
        expect(response_json[:info][:message]).to eq "Can not find orderId"
      end
    end

    context "verify signature success" do
      before do
        allow_any_instance_of(OpenSSL::PKey::RSA).to receive(:verify).and_return(true)
      end

      context "not existing maintenance_record_hub" do
        it "returns status 0" do
          post :notify, orderId: "orderId",
                        vin: "vin",
                        orderStatus: 2,
                        time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                        sign: "sign"

          expect(response.status).to eq 200
          expect(response_json[:info][:status]).to eq 0
        end
      end

      context "existing maintenance_record_hub" do
        before(:each) do
          hub_a.update(order_id: "2168a29025a84d949c38b4c7e8b6232f")
          record = MaintenanceRecord.where(maintenance_record_hub_id: hub_a.id)
                                    .first
          Token.create(company_id: record.company_id, balance: 10000)
        end
        it "returns status 1" do
          post :notify, orderId: hub_a.order_id,
                        vin: hub_a.vin,
                        orderStatus: 2,
                        time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                        sign: "sign",
                        dataJson: data_json

          expect(response.status).to eq 200
          expect(response_json[:info][:status]).to eq 1
        end

        it "updates hub status" do
          VCR.use_cassette("chejianding_parse_and_persistent_html") do
            expect do
              post :notify, orderId: hub_a.order_id,
                            vin: hub_a.vin,
                            orderStatus: 2,
                            time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                            sign: "sign",
                            dataJson: data_json
            end.to change { hub_a.reload.notify_status }
              .from(nil)
              .to(2)
          end
        end

        it "not returns back token if success" do
          VCR.use_cassette("chejianding_parse_and_persistent_html") do
            record = MaintenanceRecord.where(maintenance_record_hub_id: hub_a.id)
                                      .first
            bloc = proc do
              Token.where(company_id: record.company_id).first.balance
            end
            expect do
              post :notify, orderId: hub_a.order_id,
                            vin: hub_a.vin,
                            orderStatus: 2,
                            time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                            sign: "sign",
                            dataJson: data_json
            end.to change { bloc.call }.by(0)
          end
        end

        it "updates maintenance_records to unchecked" do
          VCR.use_cassette("chejianding_parse_and_persistent_html") do
            MaintenanceRecord.where(maintenance_record_hub_id: hub_a.id)
                             .update_all(state: :checked)
            bloc = proc do
              MaintenanceRecord.where(maintenance_record_hub_id: hub_a.id)
                               .pluck(:state).first
            end
            expect do
              post :notify, orderId: hub_a.order_id,
                            vin: hub_a.vin,
                            orderStatus: 2,
                            time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                            sign: "sign",
                            dataJson: data_json
            end.to change { bloc.call }
              .from("checked")
              .to("unchecked")
          end
        end

        it "creates OperationRecord" do
          VCR.use_cassette("chejianding_parse_and_persistent_html") do
            expect do
              post :notify, orderId: hub_a.order_id,
                            vin: hub_a.vin,
                            orderStatus: 2,
                            time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                            sign: "sign",
                            dataJson: data_json
            end.to change { OperationRecord.count }
          end
        end

        it "creates MessageJob" do
          VCR.use_cassette("chejianding_parse_and_persistent_html") do
            expect do
              post :notify, orderId: hub_a.order_id,
                            vin: hub_a.vin,
                            orderStatus: 2,
                            time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                            sign: "sign",
                            dataJson: data_json
            end.to change(MessageWorker.jobs, :size)
          end
        end

        context "通知结果为失败" do
          def record
            @_record ||= MaintenanceRecord.where(maintenance_record_hub_id: hub_a.id)
                                          .first
          end

          before do
            record.update!(state: :generating)
            company_token.update!(balance: 100.23)
            user_token.update!(balance: 20.34)
          end

          it "如果是个人支付车币，退回车币给个人" do
            record.update!(token_type: :user, token_id: user_token.id)
            post :notify, orderId: hub_a.order_id,
                          vin: hub_a.vin,
                          orderStatus: 1,
                          time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                          sign: "sign",
                          dataJson: data_json

            expect(user_token.reload.balance).to eq 20.34 + record.token_price
            expect(company_token.reload.balance).to eq 100.23
          end

          it "如果是公司支付车币，退回给公司" do
            record.update!(token_type: :company, token_id: company_token.id)
            post :notify, orderId: hub_a.order_id,
                          vin: hub_a.vin,
                          orderStatus: 1,
                          time: Time.zone.now.strftime("%Y-%m-%d %H:%M:%S"),
                          sign: "sign",
                          dataJson: data_json

            expect(user_token.reload.balance).to eq 20.34
            expect(company_token.reload.balance).to eq 100.23 + record.token_price
          end
        end
      end
    end
  end
end
