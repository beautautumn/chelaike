class TokenPolicy < ApplicationPolicy
  def index?
    true
  end

  def all?
    true
  end

  def new_index?
    true
  end
end
