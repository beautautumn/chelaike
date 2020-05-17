module EasyLoan
  class MessagesController < EasyLoan::ApplicationController
    def index
      operation_records = operation_record_scope.ordered
      render json: paginate(operation_records),
             each_serializer: EasyLoanSerializer::OperationRecordSerializer::Common,
             root: "data"
    end

    private

    def operation_record_scope
      current_user.operation_records
    end
  end
end
