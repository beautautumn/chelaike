class Intention < ActiveRecord::Base
  class ShareService
    include ErrorCollector

    class NoAssigneeError < StandardError; end
    class AssigneeNoShopError < StandardError; end

    attr_reader :intention

    def initialize(intention)
      @intention = intention
    end

    def share_to(user_ids)
      assignee = @intention.assignee
      raise NoAssigneeError, "本意向没有归属人" if assignee.blank?
      raise AssigneeNoShopError, "意向归属人#{@intention.assignee.id}没有所属店铺" if assignee.shop_id.blank?

      clear_old_relationships(user_ids)
      create_new_relationships(user_ids)
    end

    private

    def clear_old_relationships(user_ids)
      IntentionSharedUser.where(intention_id: @intention.id)
                         .where.not(user_id: user_ids)
                         .destroy_all
    end

    def create_new_relationships(user_ids)
      ids = User.where(id: user_ids, shop_id: @intention.assignee.shop_id).pluck(:id)

      ids.each do |user_id|
        IntentionSharedUser.find_or_create_by(
          intention_id: @intention.id,
          user_id: user_id
        ) do |shared_user|
          shared_user.customer_id = @intention.customer_id
        end
      end
    end
  end
end
