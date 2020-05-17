class AcquiredCarStatisticPolicy < StatisticPolicy
  def brands?
    cash_flow?
  end

  def series?
    cash_flow?
  end

  def acquirers?
    cash_flow?
  end

  def ages?
    cash_flow?
  end

  def acquisition_prices?
    cash_flow?
  end

  def acquisition_types?
    cash_flow?
  end

  def estimated_gross_profits?
    cash_flow?
  end

  def stock_ages?
    cash_flow?
  end
end
