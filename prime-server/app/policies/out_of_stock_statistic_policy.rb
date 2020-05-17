class OutOfStockStatisticPolicy < StatisticPolicy
  def stock_out_modes?
    cash_flow?
  end

  def closing_costs?
    cash_flow?
  end

  def ages?
    cash_flow?
  end

  def brands?
    cash_flow?
  end

  def series?
    cash_flow?
  end

  def appraisers?
    cash_flow?
  end

  def sellers?
    cash_flow?
  end

  def stock_ages?
    cash_flow?
  end
end
