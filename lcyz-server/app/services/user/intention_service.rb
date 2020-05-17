class User < ActiveRecord::Base
  class IntentionService
    class << self
      def related_users(user, shop_id: nil)
        scope = shop_id.blank? ? User : User.where(shop_id: shop_id)

        return scope.where(company_id: user.company_id) if super_manager?(user)
        return [user] unless user.can?("求购客户管理") || user.can?("出售客户管理")

        scope.subordinate_users_with_self(user.id)
      end

      def super_manager?(user)
        user.can?("全部客户管理") || user.can?("全部求购客户管理") || user.can?("全部出售客户管理")
      end
    end
  end
end
