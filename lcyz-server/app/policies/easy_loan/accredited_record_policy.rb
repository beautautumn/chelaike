module EasyLoan
  class AccreditedRecordPolicy < ApplicationPolicy
    def index?
      user.can?("融资管理")
    end
  end
end
