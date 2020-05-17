require "rails_helper"

RSpec.describe ChaDoctorService::Fetch do
  fixtures :all

  let(:vin) { "LFPH3ACC7A1A61382" }
  let(:failed_vin) { "asdf" }
  let(:licenseplate) { "苏EX009K" }

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:cha_doctor_record_hub) { cha_doctor_record_hubs(:cha_doctor_record_hub) }
  let(:cha_doctor_record) { cha_doctor_records(:cha_doctor_record_uncheck) }

  let(:records) { AntQueenRecord.all }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }
  let(:user_token) { tokens(:user_token) }
  let(:company_token) { tokens(:company_token) }

  describe "#execute" do
    before do
      travel_to Time.zone.local(2016, 11, 4, 12, 30, 34)
      allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")

      login_user(zhangsan)
      User.create!(
        name: "小车车",
        username: "小车车",
        phone: "xiaocheche",
        password: "xiaocheche"
      )
      # WebMock.allow_net_connect!
      # VCR.turn_off!
    end

    context "如果用户有足够车币" do
      it "创建一条用户查询记录" do
        service = ChaDoctorService::Fetch.new(vin, zhangsan)
        VCR.use_cassette("cha_doctors/fetch") do
          expect do
            service.execute
          end.to change { ChaDoctorRecord.count }.by(1)
        end
      end

      context "不支持的品牌" do
        it "报错"
      end

      context "支持的品牌" do
        context "用户选择上传图片" do
          it "只创建查询记录" do
            service = ChaDoctorService::Fetch.new("http://vin-image.com", zhangsan)
            expect do
              service.execute(true)
            end.to change { ChaDoctorRecord.count }.by 1
          end

          it "record状态为submitted" do
            vin_image = "http://vin-image.com"
            service = ChaDoctorService::Fetch.new(vin_image, zhangsan)
            service.execute(true)
            record = ChaDoctorRecord.last
            expect(record.state).to eq "submitted"
            expect(record.vin_image).to eq vin_image
            expect(record.vin).to be_nil
          end
        end

        context "hub里有未过期的报告" do
          it "不去查询，直接生成一条新的查询记录" do
            ChaDoctorRecordHub.create!(
              vin: vin, order_state: :success,
              notify_state: :success
            )

            service = ChaDoctorService::Fetch.new(vin, zhangsan)

            VCR.use_cassette("cha_doctors/fetch") do
              expect do
                service.execute
              end.to change { ChaDoctorRecordHub.count }.by(0)
            end
          end

          it "生成一条新的查询记录，支付状态为paid" do
            TokenBill.destroy_all
            ChaDoctorRecordHub.create!(
              vin: vin, order_state: :success
            )
            service = ChaDoctorService::Fetch.new(vin, zhangsan)

            VCR.use_cassette("cha_doctors/fetch") do
              service.execute
            end
            record = ChaDoctorRecord.last
            expect(record.payment_state).to eq "paid"
          end
        end

        context "hub里没有报告或报告已过期" do
          it "生成一条查博士查询报告记录,记录相应的订单ID"

          context "购买成功" do
            it "给用户扣费,并生成一条扣费操作记录"
          end

          context "购买失败" do
            it "不给用户扣费" do
              allow_any_instance_of(
                ChaDoctorService::Fetch
              ).to receive(:check_vin_avaiable?).and_return(:true)

              VCR.use_cassette("cha_doctors/fetch_failed", record: :new_episodes) do
                service = ChaDoctorService::Fetch.new(failed_vin, zhangsan)
                begin
                  service.execute
                rescue => e
                  hub = ChaDoctorRecordHub.last
                  record = ChaDoctorRecord.last

                  expect(hub).to be_persisted
                  expect(record).to be_persisted
                  expect(record.payment_state).to eq "unpaid"
                  expect(company_token.balance).to eq 100.23
                  expect(user_token.reload.balance).to eq 102.34
                  expect(e.class.name).to eq "ChaDoctorService::Fetch::ExternalError"
                end
              end
            end
          end
        end
      end
    end

    context "如果用户没有足够车币" do
      it "报错"
    end
  end

  describe "#refetch" do
    before do
      travel_to Time.zone.local(2016, 11, 4, 12, 30, 34)
      allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")

      lisi.update(company_id: zhangsan.id)

      login_user(zhangsan)
      Token.create(company_id: zhangsan.company_id, balance: 200000)

      cha_doctor_record.update(
        cha_doctor_record_hub_id: cha_doctor_record_hub.id,
        user_id: lisi.id
      )
    end

    context "用户有足够车币" do
      it "创建一条新的查询记录" do
        service = ChaDoctorService::Fetch.new(cha_doctor_record.vin, zhangsan)
        VCR.use_cassette("cha_doctors/fetch") do
          expect do
            service.refetch(cha_doctor_record)
          end.to change { ChaDoctorRecord.count }.by(1)
        end

        hub = ChaDoctorRecordHub.order(:id).last
        record = ChaDoctorRecord.order(:id).last
        expect(record.user_id).to eq zhangsan.id
        expect(record.cha_doctor_record_hub_id).to eq hub.id
      end

      context "查询成功" do
        it "扣费" do
          service = ChaDoctorService::Fetch.new(cha_doctor_record.vin, zhangsan)
          VCR.use_cassette("cha_doctors/fetch") do
            service.refetch(cha_doctor_record)

            expect(company_token.reload.balance).to eq 100.23
            expect(user_token.reload.balance).to eq 102.34 - 14
          end
        end

        it "被更新的记录所指向的报告更新为最新生成的报告" do
          service = ChaDoctorService::Fetch.new(cha_doctor_record.vin, zhangsan)
          VCR.use_cassette("cha_doctors/fetch") do
            result = service.refetch(cha_doctor_record)
            new_hub = result.hub

            expect(cha_doctor_record.reload.last_cha_doctor_record_hub).to eq new_hub
          end
        end
      end
    end
  end

  describe "#fire" do
    before do
      travel_to Time.zone.local(2016, 11, 4, 12, 30, 34)
      allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")

      login_user(zhangsan)

      cha_doctor_record.update!(token_type: :user,
                                token_id: user_token.id,
                                payment_state: :paid)
    end

    context "图片识别正确" do
      it "得到vin码，继续查询流程" do
        cha_doctor_record.update!(vin: nil, vin_image: "image-url", user_id: zhangsan.id)
        service = ChaDoctorService::Fetch.new(vin, zhangsan)
        VCR.use_cassette("cha_doctors/fetch") do
          service.fire(cha_doctor_record)
          hub = ChaDoctorRecordHub.last

          expect(cha_doctor_record.cha_doctor_record_hub_id).to eq hub.id
          expect(cha_doctor_record.last_cha_doctor_record_hub_id).to eq hub.id
          # 不再扣款
          expect(user_token.reload.balance).to eq 102.34
          expect(company_token.reload.balance).to eq 100.23
        end
      end

      context "查询同步返回失败" do
        it "给用户退车币" do
          cha_doctor_record.update!(vin: nil, vin_image: "image-url", user_id: zhangsan.id)
          service = ChaDoctorService::Fetch.new(failed_vin, zhangsan)
          allow_any_instance_of(ChaDoctorService::Fetch).to receive(:check_vin_avaiable?)
            .and_return(:true)

          VCR.use_cassette("cha_doctors/fetch_failed") do
            expect do
              service.fire(cha_doctor_record)
            end.to raise_error(ChaDoctorService::Fetch::ExternalError).and\
              change { user_token.reload.balance }.by(ChaDoctorRecord.unit_price).and\
                change { company_token.reload.balance }.by(0).and\
                  change { cha_doctor_record.reload.payment_state }.to eq "refunded"
          end
        end
      end
    end

    context "识别图片错误" do
      before do
        cha_doctor_record.update!(token_type: :user,
                                  token_id: user_token.id,
                                  payment_state: :paid,
                                  user_id: zhangsan.id
                                 )
      end

      it "不去查询" do
        cha_doctor_record.update!(vin: nil, vin_image: "image-url")
        service = ChaDoctorService::Fetch.new(vin, zhangsan)
        service.fire(cha_doctor_record, true, "tests")

        expect(cha_doctor_record.state).to eq "vin_image_fail"
      end

      it "退款" do
        cha_doctor_record.update!(vin: nil, vin_image: "image-url")
        service = ChaDoctorService::Fetch.new(vin, zhangsan)
        expect do
          service.fire(cha_doctor_record, true, "tests")
        end.to change { user_token.reload.balance }.by ChaDoctorRecord.unit_price
      end

      it "生成操作记录" do
        cha_doctor_record.update!(vin: nil, vin_image: "image-url")
        service = ChaDoctorService::Fetch.new(vin, zhangsan)
        service.fire(cha_doctor_record, true, "tests")

        record = OperationRecord.last
        expect(cha_doctor_record.state).to eq "vin_image_fail"
        expect(record.operation_record_type).to eq "vin_image_fail"
      end
    end
  end
end
