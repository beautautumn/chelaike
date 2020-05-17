class DetectionReportPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    true
  end

  def create?
    true
  end
end
