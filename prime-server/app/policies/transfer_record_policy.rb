class TransferRecordPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    User::Pundit.authorities = ["牌证信息查看"]
  end

  def show?
    index?
  end

  def update?
    User::Pundit.can_can?(user, record.car, ["牌证信息录入"])
  end
end
