require "rails_helper"

RSpec.describe Intention::ShareService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:nolan) { users(:nolan) }
  let(:doraemon) { customers(:doraemon) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }

  describe "#share_to(user_ids)" do
    before do
      doraemon_seeking_aodi.update(assignee_id: zhangsan.id)
      @service = Intention::ShareService.new(doraemon_seeking_aodi)
    end

    it "把这个意向分配给这些用户" do
      @service.share_to([lisi.id])
      expect(IntentionSharedUser.where(user_id: lisi.id).count).to eq 1
    end

    it "只能分配给相同店铺的用户" do
      @service.share_to([lisi.id, nolan.id])
      expect(IntentionSharedUser.where(intention_id: doraemon_seeking_aodi.id).count).to eq 1
    end

    it "raise error if 意向没有归属人" do
      doraemon_seeking_aodi.update(assignee_id: nil)
      service = Intention::ShareService.new(doraemon_seeking_aodi)
      expect { service.share_to([lisi.id]) }.to raise_error(
        Intention::ShareService::NoAssigneeError, "本意向没有归属人"
      )
    end

    it "raise error if 意向归属人没有所属shop" do
      zhangsan.update(shop_id: nil)
      expect { @service.share_to([lisi.id]) }.to raise_error(
        Intention::ShareService::AssigneeNoShopError, "意向归属人#{zhangsan.id}没有所属店铺"
      )
    end

    it "删除未之前分享，但本次未分享的用户" do
      @service.share_to([lisi.id])
      expect(IntentionSharedUser.where(user_id: lisi.id).count).to eq 1

      nolan.update(shop_id: zhangsan.shop_id)
      @service.share_to([nolan.id])
      expect(doraemon_seeking_aodi.shared_users).to include nolan
    end
  end
end
