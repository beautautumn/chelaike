module EasyLoan
  class LoanBillPolicy < ApplicationPolicy
    def index?
      user.can?("融资管理")
    end

    def create?
      index?
    end

    def show?
      index?
    end

    def return_apply?
      index?
    end

    def check_accredited?
      index?
    end

    def post_check?
      true
    end

    def repay?
      create?
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        @scope = if user.can?("查看全部申请单")
                   scope
                 else
                   scope.easy_loas_user_bills(user.city.split(",").last)
                 end
      end
    end
  end
end
