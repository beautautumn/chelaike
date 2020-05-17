module V1
  class Parallel::PhonesController < ApplicationController
    before_action :skip_authorization

    def show
      phone = ::Parallel::Phone.first

      render json: phone,
             serializer: ParallelPhoneSerializer::Common,
             root: "data"
    end
  end
end
