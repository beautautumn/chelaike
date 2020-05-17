# frozen_string_literal: true
module MockChelaikeHelper
  def mock_car_subscribe
    allow(Chelaike::CarService).to receive(:subscribe).and_return("ok")
  end
end
