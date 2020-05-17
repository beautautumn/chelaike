require "rails_helper"

RSpec.describe OldDriverService::Fetch do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:vin) { "LJDGAA228E0410969" }
  let(:engine_num) { "E1022420" }
  let(:license_no) { "豫A-YW186" }
  let(:id_numbers) { "440105198803260025" }
  let(:user_token) { tokens(:user_token) }
  let(:company_token) { tokens(:company_token) }

  before do
    user_token.update!(balance: 100)
    company_token.update!(balance: 200)
    travel_to Time.zone.parse("2017-03-08 17:57:30")
  end

  describe "#fetch" do
    context "用户有足够车币" do
      context "Hub里有未过期的报告"

      context "Hub里没有报告或报告已过期" do
        context "查询返回成功" do
          it "创建一条用户查询记录" do
            service = OldDriverService::Fetch.new(
              user: zhangsan,
              vin: vin,
              engine_num: engine_num,
              license_no: license_no,
              id_numbers: id_numbers
            )

            VCR.use("old_driver/fetch") do
              expect do
                service.fetch
              end.to change { OldDriverRecord.count }.by 1
            end
          end

          it "得到同步返回后创建一条报告"

          it "给用户扣款"

          it "生成相应账单"
        end

        context "查询返回失败" do
          it "不给用户扣款"
        end
      end
    end

    context "用户没有足够车币"
  end
end
