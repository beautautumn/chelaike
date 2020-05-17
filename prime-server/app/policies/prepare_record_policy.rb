class PrepareRecordPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    User::Pundit.authorities = ["整备信息查看"]
  end

  def show?
    index?
  end

  def update?
    User::Pundit.can_can?(user, record, ["整备信息录入"])
  end
end
