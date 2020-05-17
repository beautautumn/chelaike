module EasyLoan
  class AccreditedRecordPolicy < ApplicationPolicy
    def index?
      user.can?("融资管理")
    end

    def funder_companies?
      index?
    end
  end
end
