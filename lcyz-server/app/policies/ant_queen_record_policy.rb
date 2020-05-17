class AntQueenRecordPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @user
  end

  def show?
    @user.company_id == @record.company_id
  end

  def detail?
    user.can?("维保详情查看")
  end

  def refetch?
    fetch?
  end

  def fetch?
    true
  end

  def warehousing?
    fetch?
  end

  def buy?
    user.can?("车币充值")
  end
end
