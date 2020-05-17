module Che3baoConnection
  extend ActiveSupport::Concern

  included do
    establish_connection ActiveRecord::Base.configurations[Rails.env]["che3bao"]
  end

  def readonly?
    true
  end
end
