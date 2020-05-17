module V1
  class Parallel::StylesController < ApplicationController
    before_action :skip_authorization

    def index
      @styles = ::Parallel::Style.all
      phone = ::Parallel::Phone.first
      render json: @styles,
             each_serializer: ParallelStyleSerializer::Common,
             root: "data",
             meta: {
               phone: phone ? phone.slice(:number) : nil
             }
    end

    def show
      @style = ::Parallel::Style.find(params[:id])
      phone = ::Parallel::Phone.first

      render json: @style,
             serializer: ParallelStyleSerializer::Common,
             root: "data",
             meta: {
               phone: phone ? phone.slice(:number) : nil
             }
    end
  end
end
