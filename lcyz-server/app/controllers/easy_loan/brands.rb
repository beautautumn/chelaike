module EasyLoan
  class BrandsController < ApplicationController
    include Brands

    skip_before_action :authenticate_user!
  end
end
