module Dashboard
  class StaffPolicy < ::ApplicationPolicy
    def index?
      manage?
    end

    def create?
      manage?
    end

    def edit?
      manage?
    end

    def update?
      manage?
    end

    private

    def manage?
      user.admin?
    end
  end
end
