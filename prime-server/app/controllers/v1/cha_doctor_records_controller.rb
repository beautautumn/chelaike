module V1
  class ChaDoctorRecordsController < ApplicationController
    before_action only: :index do
      authorize ChaDoctorRecord
    end
    skip_after_action :verify_authorized, only: %i(fetch refetch)

    def index
      query_params_validate
      records = ChaDoctorRecord.where(company_id: current_user.company_id)
                               .includes(:cha_doctor_record_hub)
                               .order(updated_at: :desc)
      if params[:query].present? && params[:query][:vin].present?
        records = records.where("vin like ?", "%#{params[:query][:vin].upcase}%")
      end

      records = paginate records
      render json: records,
             each_serializer: ChaDoctorRecordSerializer::Basic,
             root: :data,
             meta: {
               balance: company_token.format_balance,
               user_balance: user_token.format_balance }
    end

    def show
      param! :id, Integer

      record = ChaDoctorRecord.includes(:cha_doctor_record_hub).find(params[:id])
      authorize record, :show?
      record.turn_checked!

      if params[:only_app]
        render json: record,
               serializer: MaintenanceRecordSerializer::Mini,
               root: :data
      else
        render json: record,
               serializer: ChaDoctorRecordSerializer::Detail,
               root: :data
      end
    end

    # 生成报告
    def fetch
      param! :query, Hash, required: true do |q|
        q.param! :vin, String, required: true
        q.param! :engine_num, String
        q.param! :is_image, :boolean, default: false
      end

      query = params[:query]

      policy = ChaDoctorRecordPolicy.new(current_user, nil)
      return forbidden_error("您暂无维保查询权限") unless policy.fetch?

      begin
        service = ChaDoctorService::Fetch.new(query.fetch(:vin), current_user)
        service.execute(query[:is_image])
        query_count = ChaDoctorRecord.where(vin: query[:vin]).count
      rescue ChaDoctorService::Fetch::NoEnoughTokenError => _e
        return payment_required(message: "没有剩余报告可用了，赶紧买个套餐吧")
      rescue ChaDoctorService::Fetch::ExternalError => e
        return payment_required(message: e.message)
      rescue ChaDoctorService::Fetch::InternalError => _e
        return payment_required(message: "系统内部出错")
        # 发送邮件给相应开发
      end

      render(status: 200, json: { data: { query_count: query_count } }, scope: nil)
    end

    # 刷新报告
    def refetch
      param! :id, Integer

      policy = ChaDoctorRecordPolicy.new(current_user, nil)
      return forbidden_error("您暂无维保查询权限") unless policy.refetch?

      record = ChaDoctorRecord.find(params[:id])

      begin
        service = ChaDoctorService::Fetch.new(record.vin, current_user)
        service.refetch(record)
        query_count = ChaDoctorRecord.where(vin: record.vin).count
      end

      render(status: 200, json: { data: { query_count: query_count } }, scope: nil)
    end

    def warehousing
      record = ChaDoctorRecord.find(params[:id])
      authorize record, :warehousing?
      render json: record,
             serializer: ChaDoctorRecordSerializer::Warehousing,
             root: :data
    end

    private

    def company_token
      Token.get_or_create_token!(current_user.company)
    end

    def user_token
      Token.get_or_create_token!(current_user)
    end

    def query_params_validate
      param! :query, Hash do |b|
        b.param! :vin, String, transform: :upcase, required: true
      end
      param! :page, Integer, default: 1
      param! :per_page, Integer, default: 25
    end
  end
end
