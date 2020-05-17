module V1
  class BrandsController < ApplicationController
    include Brands

    skip_before_action :authenticate_user!
    before_action :skip_authorization
    serialization_scope :anonymous

    def scope
      current_user
    end
  end
end
