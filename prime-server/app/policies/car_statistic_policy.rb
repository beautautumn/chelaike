class CarStatisticPolicy < StatisticPolicy
  def overview?
    return true if record.range == "day"

    cash_flow?
  end
end
