module V1
  class Che3baoMigrationsController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :skip_authorization

    serialization_scope :anonymous

    def create
      corp = Che3bao::Corp.find(params[:corp_id])
      company = Company.find_by(name: corp.name)

      if company.present?
        forbidden_error
      else
        Che3baoMigrationsWorker.perform_async(params[:corp_id])
        render nothing: true
      end
    end
  end
end
