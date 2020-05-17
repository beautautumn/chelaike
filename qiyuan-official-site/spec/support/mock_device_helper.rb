# frozen_string_literal: true
module MockDeviceHelper
  def mock_mobile
    request.user_agent = "mozilla/5.0 (iphone; cpu iphone os 5_1_1 like mac os x)" \
    " applewebkit/534.46 (khtml, like gecko) mobile/9b206 micromessenger/5.0"
  end

  def mock_descktop
    request.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3)" \
    " AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36"
  end
end
