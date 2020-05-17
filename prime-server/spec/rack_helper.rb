module RackHelper
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      run Rails.application
    end.to_app
  end
end
