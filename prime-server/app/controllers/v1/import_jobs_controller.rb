module V1
  class ImportJobsController < ApplicationController
    def show
      job = Sidekiq::Status.get_all(params[:id])

      render json: { data: job }, scope: nil
    end
  end
end
