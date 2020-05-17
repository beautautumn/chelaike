module MaintenancePriceHelper
  def mock_prices
    allow(ChaDoctorRecord).to receive(:unit_price).and_return(14)
    allow(AntQueenRecord).to receive(:unit_price).and_return(19)
    allow(DashenglaileRecord).to receive(:unit_price).and_return(29)
  end
end
