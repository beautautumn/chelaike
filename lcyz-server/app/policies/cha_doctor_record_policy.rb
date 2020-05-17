class ChaDoctorRecordPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    @user.company_id == @record.company_id
  end

  def warehousing?
    fetch?
  end

  def fetch?
    true
  end

  def refetch?
    fetch?
  end
end
