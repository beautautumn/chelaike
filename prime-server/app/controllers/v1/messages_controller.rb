module V1
  class MessagesController < ApplicationController
    before_action :skip_authorization

    after_action :mark_as_read!, only: [:index, :show]

    def index
      @operation_records = operation_record_scope.ransack(params[:query]).result.ordered

      if params[:stock_out_type].present?
        @operation_records = @operation_records.stock_out(params[:stock_out_type])
      end

      render json: paginate(@operation_records),
             each_serializer: OperationRecordSerializer::Common,
             root: "data"
    end

    def show
      render json: current_user.operation_records.find(params[:id]),
             serializer: OperationRecordSerializer::Common,
             root: "data"
    end

    def unread
      render json: { data: { unread_count: current_user.unread_operation_records.count } }
    end

    def categoried_index
      param! :category, String, in: %w(statistics stock customer system loan)

      groups = RongMessageService::TYPE_GROUP_MAP.fetch(params[:category].to_sym)

      record_types = []
      groups.each do |group|
        record_types += OperationRecord.send("operation_record_type_#{group}")
      end

      scope = operation_record_scope.where(operation_record_type: record_types)

      # query = { "targetable_of_Car_type_brand_name_or_targetable_of_Car_type_series_name_eq"
      # => "奥迪" } # 车型车系查询
      # query = { "targetable_of_Car_type_name_or_targetable_of_Car_type_stock_number
      # _or_targetable_of_Car_type_vin_cont"
      # => "abc123" } # 搜索
      # query = { "targetable_of_EasyLoan::AccreditedRecord_type_funder_company_name_cont"
      # => "天车很有钱" }
      operation_records = scope.ransack(params[:query]).result.ordered

      if params[:stock_out_type].present?
        operation_records = operation_records.stock_out(params[:stock_out_type])
      end

      render json: paginate(operation_records),
             each_serializer: OperationRecordSerializer::Common,
             root: "data"
    end

    # 临时调试测试server端发送给app端消息
    def server_send
      user_ids = [367]
      content = {
        content: "this is content",
        extra: { car_id: 1,
                 message_type: "message_type",
                 operation_record_id: 1,
                 notification_type: :stock }
      }

      Util::RongPush.new(-200, user_ids, content).send
    end

    private

    def mark_as_read!
      current_user.messages.mark_as_read!
    end

    def operation_record_scope
      current_user.operation_records
    end
  end
end
