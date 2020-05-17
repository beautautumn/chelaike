module Dashboard
  class OperationRecordsController < ApplicationController
    skip_after_action :verify_authorized

    def index
      @operation_records = OperationRecord.includes(:staff)
                                          .order(created_at: :desc)
                                          .ransack(params[:q])
                                          .result
                                          .page(params[:page])
                                          .per(20)
      @counter = OperationRecord.ransack(params[:q]).result.count
    end
  end
end
