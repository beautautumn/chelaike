class CarReservationPolicy < ApplicationPolicy
  def manage?
    user.can?("在库车辆预定")
  end
end
