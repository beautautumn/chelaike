module V1
  class DashenglaileRecordsController < ApplicationController
    before_action only: :index do
      authorize DashenglaileRecord
    end
    skip_after_action :verify_authorized, only: %i(fetch refetch)

    def index
      query_params_validate
      records = DashenglaileRecord.where(company_id: current_user.company_id)
                                  .includes(:dashenglaile_record_hub, :car)
                                  .order(last_fetch_at: :desc)
      if params[:query].present? && params[:query][:vin].present?
        records = records.where("vin like ?", "%#{params[:query][:vin].upcase}%")
      end

      records = paginate records
      token = ::Token.get_or_create_token!(current_user.company)
      user_token = ::Token.get_or_create_token!(current_user)
      balance = token.format_balance
      user_balance = user_token.format_balance

      render json: records,
             each_serializer: DashenglaileRecordSerializer::Basic,
             root: :data,
             meta: {
               balance: balance,
               user_balance: user_balance
             }
    end

    def show
      param! :id, Integer

      record = DashenglaileRecord.includes(:car, :dashenglaile_record_hub).find(params[:id])
      authorize record, :show?
      record.turn_checked!

      if params[:only_app]
        render json: record,
               serializer: MaintenanceRecordSerializer::Mini,
               root: :data
      else
        render json: record,
               serializer: DashenglaileRecordSerializer::Detail,
               root: :data
      end
    end

    def detail
      param! :query, Hash, required: true do |b|
        b.param! :car_id, Integer, required: false
      end
      @car = Car.find(params[:query][:car_id])
      authorize DashenglaileRecord, :detail?
      detail_fetch
      wrapper = CombinedSerializers.new(
        dashenglaile_record: @record || DashenglaileRecord.new,
        maintenance_images: @car.maintenance_images
      )
      render json: wrapper,
             serializer: DashenglaileRecordSerializer::Wrapper,
             root: :data
    end

    def fetch
      param! :query, Hash, required: true do |q|
        q.param! :vin, String, required: true
        q.param! :car_id, Integer, required: false
        q.param! :brand_id, Integer
        q.param! :is_image, :boolean, default: false
        q.param! :engine_num, String
      end

      policy = DashenglaileRecordPolicy.new(current_user, nil)
      return forbidden_error("您暂无维保查询权限") unless policy.fetch?

      process_token(params[:query][:vin].upcase, params[:query][:brand_id]) do |token|
        fetch_process(token)
      end

    rescue Dashenglaile::Error::Vendor => e
      render(status: 402, json: { message: e.message }, scope: nil)
    rescue *Dashenglaile::FetchService::ERRORS => _e
      render(status: 402, json: { message: "服务暂不可用，请稍后重试" }, scope: nil)
    end

    def refetch
      param! :id, Integer

      policy = DashenglaileRecordPolicy.new(current_user, nil)
      return forbidden_error("您暂无维保查询权限") unless policy.refetch?

      record = DashenglaileRecord.find(params[:id])

      process_token(record.vin, record.car_brand_id) do |token|
        refetch_process(record, token)
      end

    rescue Dashenglaile::Error::Vendor => e
      render(status: 402, json: { message: e.message }, scope: nil)
    rescue *Dashenglaile::FetchService::ERRORS => _e
      render(status: 402, json: { message: "服务暂不可用，请稍后重试" }, scope: nil)
    end

    def warehousing
      record = DashenglaileRecord.find(params[:id])
      authorize record, :warehousing?
      render json: record,
             serializer: DashenglaileRecordSerializer::Warehousing,
             root: :data
    end

    private

    def detail_fetch
      @record = DashenglaileRecord.find_by(car_id: params[:query][:car_id]) ||
                (@car.vin.presence &&
                  DashenglaileRecord.find_by(vin: @car.vin, company_id: current_user.company_id))
      return unless @record
      @record.car_id = @car.id
      @record.state = :checked if @record.state.unchecked?
      @record.save!
    end

    def process_token(vin, brand_id)
      token = ::Token.get_or_create_token!(current_user.company)
      user_token = ::Token.get_or_create_token!(current_user)

      token_price = DashenglaileRecord.unit_price(
        car_brand_id: brand_id,
        company: current_user.company
      )

      token.with_lock do
        if user_token.balance.to_d >= token_price
          yield user_token
        elsif token.balance.to_d >= token_price && current_user.can?("维保报告查询")
          yield token
        else
          return payment_required(message: "没有剩余报告可用了，赶紧买个套餐吧")
        end

        query_count = DashenglaileRecord.where(vin: vin).count
        return render(status: 200, json: { data: { query_count: query_count } }, scope: nil)
      end
    end

    def fetch_process(token)
      options = {
        action: :new,
        car_id: params[:query][:car_id],
        brand_id: params[:query][:brand_id],
        is_image: params[:query][:is_image],
        engine_num: params[:query][:engine_num]
      }
      service = Dashenglaile::FetchService.new(params[:query][:vin],
                                               current_user,
                                               token,
                                               options)
      service.execute
    end

    def refetch_process(record, token)
      if record.image_mode?
        is_image = true
        vin = record.vin_image
      else
        is_image = false
        vin = record.vin
      end
      options = {
        action: :refetch,
        record: record,
        car_id: record.car_id,
        engine_num: record.engine_num,
        is_image: is_image
      }
      service = Dashenglaile::FetchService.new(vin, current_user, token, options)
      service.execute
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
