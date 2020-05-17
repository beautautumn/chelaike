module CheRongYi
  class RepaymentBillPolicy < ApplicationPolicy
    def index?
      user.can?("融资管理")
    end

    def create?
      user.can?("融资管理")
    end

    def show?
      create?
    end

    def apply?
      create?
    end
  end
end
