module V1
  class RedDotsController < ApplicationController
    skip_after_action :verify_authorized

    def index
      maintenance_record = MaintenanceRecord.where(company_id: current_user.company_id,
                                                   state: :unchecked)
                                            .count
      render json: { data: { maintenance_record: maintenance_record } }, scope: nil
    end
  end
end
