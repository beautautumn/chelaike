require "rails_helper"

RSpec.describe Intention::ListService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:doraemon) { customers(:doraemon) }
  let(:cruise) { customers(:cruise) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:gian_seeking_aodi) { intentions(:gian_seeking_aodi) }
  let(:cruise_sell_aodi) { intentions(:cruise_sell_aodi) }
  let(:shizuka_seeking_aodi) { intentions(:shizuka_seeking_aodi) }

  def service_params(extra_params = {})
    {
      order_by: "desc",
      page: 1,
      per_page: 25,
      order_field: "due_time"
    }.merge(extra_params)
  end

  describe "#execute" do
    context "普通销售人员权限" do
      before do
        lisi.update(manager_id: nil)
      end

      context "没有共享给自己的意向" do
        it "返回所有归属人是自己的意向" do
          service = Intention::ListService.new(zhangsan, service_params)
          scope = service.execute
          expect(scope.count).to eq 4
        end
      end

      context "有共享给自己的意向" do
        it "返回列表里包含共享的意向" do
          IntentionSharedUser.create(user_id: zhangsan.id, intention_id: gian_seeking_aodi.id)
          service = Intention::ListService.new(zhangsan, service_params)
          scope = service.execute
          expect(scope).to include gian_seeking_aodi
        end
      end
    end

    context "销售管理或者是他人的manager"
  end
end
