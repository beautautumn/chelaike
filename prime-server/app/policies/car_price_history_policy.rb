class CarPriceHistoryPolicy < ApplicationPolicy
  def manage?
    user.can?("车辆销售定价")
  end
end
