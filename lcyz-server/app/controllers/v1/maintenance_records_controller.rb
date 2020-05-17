module V1
  class MaintenanceRecordsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:shared_detail]

    before_action only: [:index, :statistics, :export] do
      authorize MaintenanceRecord
    end

    skip_after_action :verify_authorized, only: [:fetch, :refetch, :time_hint, :shared_detail]

    def index
      query_params_validate
      records = MaintenanceRecord.where(company_id: current_user.company_id).real
                                 .includes(:maintenance_record_hub, :car)
                                 .order(last_fetch_at: :desc)
      if params[:query].present? && params[:query][:vin].present?
        records = records.where("vin like ?", "%#{params[:query][:vin].upcase}%")
      end

      records = paginate records

      render json: records,
             each_serializer: MaintenanceRecordSerializer::Basic,
             root: :data,
             meta: {
               balance: company_token.format_balance,
               user_balance: user_token.format_balance,
               token_price: MaintenanceRecord.unit_price.to_f }
    end

    def show
      param! :id, Integer

      record = MaintenanceRecord.includes(:car, :maintenance_record_hub).find(params[:id])
      authorize record, :show?
      record.turn_checked!

      if params[:only_app]
        render json: record,
               serializer: MaintenanceRecordSerializer::Mini,
               root: :data
      else
        render json: record,
               serializer: MaintenanceRecordSerializer::Detail,
               root: :data
      end
    end

    def detail
      param! :query, Hash, required: true do |b|
        b.param! :car_id, Integer, required: false
      end
      authorize MaintenanceRecord, :detail?

      car_id = params[:query][:car_id]
      @car = Car.find_by(id: car_id)
      detail_fetch(car_id)
      ant_queen_fetch(car_id)
      cha_doctor_fetch(car_id)
      dasheng_fetch(car_id)
      wrapper = CombinedSerializers.new(
        ant_queen_record: @ant_queen || AntQueenRecord.new,
        cha_doctor_record: @cha_doctor || ChaDoctorRecord.new,
        maintenance_record: @record || MaintenanceRecord.new,
        dashenglaile_record: @dasheng || DashenglaileRecord.new,
        maintenance_images: @car.try(:maintenance_images)
      )

      render json: wrapper,
             serializer: MaintenanceRecordSerializer::Wrapper,
             root: :data
    end

    def upload_images
      param! :car_id, Integer, required: true

      car = Car.find(params[:car_id])
      authorize car, :show?
      car.update!(images_params)
      render json: car,
             serializer: MaintenanceRecordSerializer::Image,
             root: :data,
             include: "**"
    end

    def share_record
      param! :provider_id, Integer, required: true
      param! :id, Integer, required: true

      skip_authorization

      provider_id_map = {
        1 => :ant_queen,
        2 => :cha_doctor,
        3 => :dasheng,
        4 => :che_jian_ding
      }

      provider_name = provider_id_map.fetch(params[:provider_id])
      _, title, provider = MaintenanceRecord.find_share_record(provider_name, params[:id])

      shared_key = MaintenanceRecord.shared_key(provider_name, params[:id])
      shared_url = case Rails.env
                   when "production", "dashboard"
                     # "http://evaluate.chelaike.com/#/#{shared_key}"
                     "http://evaluate.lcyzauto.com/#/#{shared_key}"
                   when "bm_production"
                     "http://bm_evaluate.chelaike.cn/#/#{shared_key}"
                   else
                     "http://evaluate.lina.server.chelaike.com/#/#{shared_key}"
                   end

      render json: { data:
                     {
                       url: shared_url,
                       title: "#{title}报告--#{provider}",
                       shared_key: shared_key,
                       desc: ENV.fetch("MAINTENANCE_RECORD_DESC"),
                       img_url: ENV.fetch("MAINTENANCE_RECORD_IMAGE_URL")
                     }
                   }
    end

    # 不需要登录的情况下给出维保详情
    def shared_detail
      param! :shared_key, String, required: true
      skip_authorization

      password = Digest::SHA256.digest(ENV["AES_PASSWORD"])
      iv = ENV["AES_IV"]
      result = Util::AesCrypt.decrypt(password, iv, params[:shared_key])
      # platform=che_jian_ding&record_id=707830668

      parsed_hash = result.split("&").map { |arr| arr.split("=") }.to_h
      platform = parsed_hash.fetch("platform").to_sym
      record_id = parsed_hash.fetch("record_id")

      platform_class_map = {
        ant_queen: "AntQueenRecord",
        cha_doctor: "ChaDoctorRecord",
        dasheng: "DashenglaileRecord",
        che_jian_ding: "MaintenanceRecord",
        old_driver: "OldDriverRecord"
      }

      platform_code_map = {
        ant_queen: 1,
        cha_doctor: 2,
        dasheng: 3,
        che_jian_ding: 4,
        old_driver: 5
      }

      class_str = platform_class_map.fetch(platform.to_sym).classify
      record = class_str.constantize.find(record_id)

      render json: record,
             serializer: "#{class_str}Serializer::Detail".constantize,
             root: :data,
             meta: { platform_code: platform_code_map.fetch(platform) },
             scope: nil
    rescue StandardError => e
      forbidden_error(e.message)
    end

    def warehousing
      maintenance_record = MaintenanceRecord.find(params[:id])
      authorize maintenance_record, :warehousing?
      render json: maintenance_record,
             serializer: MaintenanceRecordSerializer::Warehousing,
             root: :data
    end

    # TODO: 增加锁定功能，用来锁定车币
    # TODO: refactoring fetch and refetch action
    # 查询时
    # 如果有可用的缓存，直接读取缓存，并消费车币。
    # 如果没有可用的缓存，查车鉴定，等待车鉴定直接返回成功后，扣除车币
    # 如果回调返回失败，再将车币退还
    def fetch
      param! :query, Hash, required: true do |q|
        q.param! :vin, String, required: true
        q.param! :car_id, Integer, required: false
        q.param! :engine, String, required: false
        q.param! :is_image, :boolean, default: false
        q.param! :license_plate, String, required: false
      end

      policy = MaintenanceRecordPolicy.new(current_user, nil)
      return forbidden_error("抱歉，车鉴定暂时不支持查询！给你带来不便，敬请谅解！")

      # return forbidden_error("您暂无维保查询权限") unless policy.fetch?
      # vin = params[:query][:vin].upcase

      # process_token(vin) do |token|
      #   fetch_process(token)
      # end
    end

    # 更新时
    # 直接查询车鉴定，等待车鉴定直接返回成功后，扣除车币
    # 如果回调返回失败，再将车币退还
    def refetch
      param! :id, Integer
      policy = MaintenanceRecordPolicy.new(current_user, nil)
      return forbidden_error("您暂无维保查询权限") unless policy.refetch?

      record = MaintenanceRecord.find(params[:id])

      process_token(record.vin) do |token|
        refetch_process(record, token)
      end
    end

    def statistics
      param! :query, Hash do |q|
        q.param! :fetch_by, String
        q.param! :year, String
        q.param! :month, String
      end
      param! :page, Integer, default: 1
      param! :per_page, Integer, default: 25

      stored_count, records = process_statistics

      total_count = records.size
      page_record = Kaminari::PaginatableArray.new(
        records,
        limit: params[:per_page],
        offset: ((num = params[:page] - 1) < 0 ? 0 : num) * params[:per_page]
      )
      render json: page_record,
             each_serializer: MaintenanceRecordSerializer::Statistics,
             root: :data,
             meta: { stored_count: stored_count, total_count: total_count }
    end

    def export
      param! :query, Hash do |q|
        q.param! :fetch_by, String
        q.param! :year, String
        q.param! :month, String
      end

      _, records = process_statistics

      title = %w(车架号 查询人 查询时间 车辆状态 查询平台 品牌车系 消费车币)

      format = export_format(records)

      name = "维保记录统计#{Time.zone.now.strftime("%Y%m%d")}.xls"

      headers["Cache-Control"] = "no-cache"
      headers["Content-Type"] = "text/event-stream; charset=utf-8"
      headers["Content-disposition"] = "attachment; filename=\"#{name}\""
      headers["X-Accel-Buffering"] = "no"
      headers.delete("Content-Length")

      self.response_body = HoneySheet::Excel.package(name, title, format)
    end
    # rubocop:enable Metrics/AbcSize

    def time_hint
      now = Time.zone.now
      start_time, end_time = MaintenanceRecord::WorkingHours
      start_at =  now.change(hour: start_time[:hour], min: start_time[:min])
      end_at = now.change(hour: end_time[:hour], min: end_time[:min])
      time_hint = if now < start_at
                    "工作时间8:30-20:00，非工作时间的查询将在今天8:30上班后处理".freeze
                  elsif now > end_at
                    "工作时间8:30-20:00，非工作时间的查询将在次日8:30上班后处理".freeze
                  else
                    ""
                  end
      render json: { data: { time_hint: time_hint } }, scope: nil
    end

    private

    def process_token(vin)
      token = Token.get_or_create_token!(current_user.company)
      user_token = Token.get_or_create_token!(current_user)

      token.with_lock do
        if user_token.balance.to_d >= MaintenanceRecord.unit_price
          yield user_token
        elsif token.balance.to_d >= MaintenanceRecord.unit_price &&
              current_user.can?("维保报告查询")
          yield token
        else
          return payment_required(message: "没有剩余报告可用了，赶紧买个套餐吧")
        end
        query_count = MaintenanceRecord.where(vin: vin).count
        return render(status: 200, json: { data: { query_count: query_count } }, scope: nil)
      end
    end

    def company_token
      Token.get_or_create_token!(current_user.company)
    end

    def user_token
      Token.get_or_create_token!(current_user)
    end

    def fetch_date(year, month)
      if month.present?
        gt = Time.zone.local(year, month)
        lt = gt.next_month
      else
        gt = Time.zone.local(year)
        lt = gt.next_year
      end
      [gt, lt]
    end

    def statistics_scope(scope, query)
      fetch_by = query[:fetch_by].present? ? query[:fetch_by].to_i : nil
      year = query[:year].present? ? query[:year].to_i : nil
      month = query[:month].present? ? query[:month].to_i : nil
      scope = scope.where(last_fetch_by: fetch_by) if fetch_by
      scope = scope.by_fetch_at_range(*fetch_date(year, month)) if year
      scope
    end

    def process_statistics
      scope1 = MaintenanceRecord.where(company_id: current_user.company_id).real.success
      scope2 = AntQueenRecord.includes(:ant_queen_record_hub).success
                             .where(company_id: current_user.company_id)
      query = params[:query] || {}

      scope1 = statistics_scope(scope1, query)
      scope2 = statistics_scope(scope2, query)

      stored_count = scope1.car_stored.size + scope2.car_stored.size
      records = (scope1 + scope2).sort_by { |r| r.last_fetch_at.to_i }.reverse

      [stored_count, records]
    end

    def images_params
      params.permit(
        maintenance_images_attributes: [:id, :url, :location, :sort, :is_cover, :_destroy]
      )
    end

    def refetch_process(record, token)
      options = { action: :refetch,
                  car_id: record.car_id,
                  record: record, engine: record.engine,
                  license_plate: record.license_plate }
      service = Maintenance::FetchService.new(record.vin,
                                              current_user,
                                              token,
                                              options)
      service.execute
    end

    def fetch_process(token)
      options = {
        action: :new,
        car_id: params[:query][:car_id],
        engine: params[:query][:engine],
        is_image: params[:query][:is_image],
        license_plate: params[:query][:license_plate]
      }

      service = Maintenance::FetchService.new(params[:query][:vin],
                                              current_user,
                                              token,
                                              options)
      service.execute
    end

    def detail_fetch(car_id)
      return unless @car
      @record = MaintenanceRecord.where(car_id: car_id).order(:created_at).last ||
                (@car.vin.presence &&
                  MaintenanceRecord.find_by(vin: @car.vin, company_id: current_user.company_id))
      return unless @record
      @record.car_id = @car.id
      @record.state = :checked if @record.state.unchecked?
      @record.save!
    end

    def ant_queen_fetch(car_id)
      return unless @car
      @ant_queen = AntQueenRecord.where(car_id: car_id).order(:created_at).last ||
                   (@car.vin.presence &&
                     AntQueenRecord.find_by(vin: @car.vin, company_id: current_user.company_id))
      return unless @ant_queen
      @ant_queen.car_id = @car.id
      @ant_queen.state = :checked if @ant_queen.state.unchecked?
      @ant_queen.save!
    end

    def cha_doctor_fetch(car_id)
      return unless @car
      @cha_doctor = ChaDoctorRecord.where(car_id: car_id).order(:created_at).last ||
                    (@car.vin.presence &&
                      ChaDoctorRecord.find_by(vin: @car.vin, company_id: current_user.company_id))
      return unless @cha_doctor
      @cha_doctor.car_id = @car.id
      @cha_doctor.state = :checked if @cha_doctor.state.unchecked?
      @cha_doctor.save!
    end

    def dasheng_fetch(car_id)
      return unless @car
      @dasheng = DashenglaileRecord.where(car_id: car_id).order(:created_at).last ||
                 (@car.vin.presence &&
                    DashenglaileRecord.find_by(vin: @car.vin, company_id: current_user.company_id))
      return unless @dasheng
      @dasheng.car_id = @car.id
      @dasheng.state = :checked if @dasheng.state.unchecked?
      @dasheng.save!
    end

    def query_params_validate
      param! :query, Hash do |b|
        b.param! :vin, String, required: false
      end
      param! :page, Integer, default: 1
      param! :per_page, Integer, default: 25
    end

    def export_format(records)
      platform_map = {
        "AntQueenRecord" => "蚂蚁女王",
        "MaintenanceRecord" => "车鉴定"
      }

      records.map do |r|
        [
          r.real_vin,
          r.user_name,
          r.last_fetch_at.strftime("%Y-%m-%d"),
          r.stored ? "已入库".freeze : "未入库".freeze,
          platform_map.fetch(r.class.name, "车鉴定"),
          r.car_name, # 品牌车系
          r.token_price
        ]
      end
    end
  end
end
