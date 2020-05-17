module V1
  class OldDriverRecordsController < ApplicationController
    before_action only: :index do
      authorize OldDriverRecord
    end
    skip_after_action :verify_authorized, only: %i(fetch refetch)

    def index
      query_params_validate
      records = OldDriverRecord.where(company_id: current_user.company_id)
                               .includes(:old_driver_record_hub)
                               .order(updated_at: :desc)
      if params[:query].present? && params[:query][:vin].present?
        records = records.where("vin like ?", "%#{params[:query][:vin].upcase}%")
      end

      records = paginate records
      render json: records,
             each_serializer: OldDriverRecordSerializer::Basic,
             root: :data,
             meta: {
               balance: company_token.format_balance,
               user_balance: user_token.format_balance }
    end

    def fetch
      param! :query, Hash, require: true do |q|
        q.param! :vin, String, required: true
        q.param! :engine_num, required: false
        q.param! :license_no, required: false
      end

      query = params[:query]

      policy = OldDriverRecordPolicy.new(current_user, nil)

      return forbidden_error("您暂无维保查询权限") unless policy.fetch?
      begin
        service = OldDriverService::Fetch.new(
          user: current_user,
          vin: query.fetch(:vin),
          engine_num: query.fetch(:engine_num),
          license_no: query.fetch(:license_no)
        )
        service.fetch
      rescue OldDriverService::Fetch::NoEnoughTokenError => _e
        return payment_required(message: "没有剩余报告可用了，赶紧买个套餐吧")
      rescue OldDriverService::Fetch::ExternalError => _e
        return forbidden_error("vin码非法，不能查询")
      end

      render json: { data: { message: "ok" } }, scope: nil
    end

    # 报告更新
    def refetch
      param! :id, Integer

      policy = OldDriverRecordPolicy.new(current_user, nil)
      return forbidden_error("您暂无维保查询权限") unless policy.fetch?

      record = OldDriverRecord.find(params[:id])

      begin
        service = OldDriverService::Fetch.new(
          user: current_user,
          vin: record.vin
        )
        service.refetch(record)
      rescue OldDriverService::Fetch::NoEnoughTokenError => _e
        return payment_required(message: "没有剩余报告可用了，赶紧买个套餐吧")
      rescue OldDriverService::Fetch::ExternalError => e
        return payment_required(message: e.message)
      end

      render json: { data: { message: "ok" } }, scope: nil
    end

    def show
      param! :id, Integer

      record = OldDriverRecord.includes(:old_driver_record_hub).find(params[:id])
      authorize record, :show?
      record.turn_checked!

      if params[:only_app]
        render json: record,
               serializer: OldDriverRecordSerializer::Mini,
               root: :data
      else
        render json: record,
               serializer: OldDriverRecordSerializer::Detail,
               root: :data
      end
    end

    def warehousing
      record = OldDriverRecord.find(params[:id])
      authorize record, :warehousing?
      render json: record,
             serializer: OldDriverRecordSerializer::Warehousing,
             root: :data
    end

    # 得到所有的保险理赔记录
    def detail
      param! :query, Hash, required: true do |b|
        b.param! :car_id, Integer, required: false
      end
      authorize OldDriverRecord, :detail?

      car_id = params[:query][:car_id]
      record = detail_fetch(car_id)

      if record
        render json: record,
               serializer: OldDriverRecordSerializer::Detail,
               root: :data
      else
        render json: { data: nil }, scope: nil
      end
    end

    # 分享到微信
    def share_record
      param! :id, Integer, required: true

      skip_authorization

      provider_name = "old_driver"
      title = OldDriverRecord.find(params[:id]).make
      provider = "查个车"

      shared_key = MaintenanceRecord.shared_key(provider_name, params[:id])
      shared_url = case Rails.env
                   when "production", "dashboard"
                     "http://share.chelaike.com/insurance/#{shared_key}"
                   else
                     "http://share.lina.server.chelaike.com/insurance/#{shared_key}"
                   end
      render json: { data:
                     {
                       url: shared_url,
                       title: "#{title}报告--#{provider}",
                       shared_key: shared_key,
                       desc: "车来客支持查车辆保险理赔记录。收车查保险，更靠谱有保障！",
                       img_url: ENV.fetch("MAINTENANCE_RECORD_IMAGE_URL")
                     }
                   }
    end

    private

    def detail_fetch(car_id)
      car = Car.find_by(id: car_id)
      return unless car
      record = OldDriverRecord.where(car_id: car_id).order(:created_at).last ||
                (car.vin.presence &&
                 OldDriverRecord.find_by(vin: car.vin, company_id: current_user.company_id))
      return unless record
      record.car_id = car.id
      record.state = :checked if record.state.unchecked?
      record.save!

      record
    end

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
