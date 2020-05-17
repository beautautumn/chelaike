# 联盟公司里的意向管理
module V1
  module AllianceDashboard
    class IntentionsController < V1::AllianceDashboard::ApplicationController
      def index
        intentions = fetch_intentions(true)
        render json: intentions,
               each_serializer: AllianceDashboardSerializer::IntentionSerializer::Intention,
               root: "data", include: "**"
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
      def export
        intentions = fetch_intentions(false)

        title = %w(
          编号 意向类型 姓名 联系电话 性别 来源 等级 归属人
          创建人 创建日期 跟进状态 最新跟进时间 下次跟进日期 意向内容
          意向车型 到店次数 跟进次数 意向跟进历史
        )

        states = {
          "pending" => "创建",
          "completed" => "成交",
          "failed" => "战败",
          "interviewed" => "预约",
          "invalid" => "无效",
          "processing" => "跟进",
          "reserved" => "预定",
          "cancel_reserved" => "取消",
          "hall_consignment" => "厅寄",
          "online_consignment" => "网寄"
        }

        format = intentions.map do |r|
          [
            r.id, # 编号
            r.intention_type_text, # 意向类型
            r.customer_name, # 姓名
            r.customer_phone, # 联系电话
            r.gender_text, # 性别
            r.channel.try(:name), # 来源
            r.intention_level.try(:name), # 等级
            r.assignee.try(:name), # 归属人
            r.creator.try(:name), # 创建人
            r.created_at.to_date, # 创建时间
            r.alliance_state_text, # 跟进状态
            # 最新跟进时间
            r.latest_intention_push_history.try(:created_at).try(:to_date),
            r.processing_time.try(:to_date), # 下次跟进日期
            r.intention_note, # 意向内容
            r.intention_cars_text, # 意向车型
            r.checked_count, # 到店次数
            r.intention_push_histories.size, # 跟进次数
            r.intention_push_histories.reduce("") do |content, history|
              content += "#{history.executor.try(:name)}进行“#{states[history.state]}”操作 &#10; "
              content += "第#{history.checked_count}次到店 &#10; " if history.checked_count
              content += "成交车辆：#{history.closing_car_name} &#10; " if history.closing_car_name
              if history.closing_car
                car_name = history.closing_car.name
                car_stock = history.closing_car.stock_number
                content += "成交车辆：#{car_name} （#{car_stock}） &#10; "
              end
              if history.interviewed_time
                content += "下次预约时间：#{history.interviewed_time.strftime("%F")} &#10; "
              end
              if history.processing_time
                content += "下次跟进时间：#{history.processing_time.strftime("%F")} &#10; "
              end
              content += "跟进说明：#{history.note} &#10; \r\n" if history.note
              content += "#{history.created_at.strftime("%F %T")} &#10; "
              content + " &#10; "
            end
          ]
        end

        name = "意向导出#{Time.zone.now.strftime("%Y%m%d")}.xls"

        headers["Cache-Control"] = "no-cache"
        headers["Content-Type"] = "text/event-stream; charset=utf-8"
        headers["Content-disposition"] = "attachment; filename=\"#{name}\""
        headers["X-Accel-Buffering"] = "no"
        headers.delete("Content-Length")

        self.response_body = HoneySheet::Excel.package(name, title, format)
      end

      def show
        render json: Intention.find(params[:id]),
               serializer: IntentionSerializer::Common,
               root: "data", include: "**"
      end

      def create
        service = AllianceCompanyService::Intentions::Create.new(
          current_user, intention_params
        )

        service.create

        if service.valid?
          render json: service.intention,
                 serializer: IntentionSerializer::Common,
                 root: "data", include: "**"
        else
          validation_error(full_errors(service.intention))
        end
      end

      def update
        intention = Intention.find(params[:id])
        service = AllianceCompanyService::Intentions::Update.new(
          current_user, intention, intention_params
        )

        service.update

        if service.valid?
          render json: service.intention,
                 serializer: IntentionSerializer::Common,
                 root: "data", include: "**"
        else
          validation_error(full_errors(service.intention))
        end
      end

      def destroy
        intention = intention_scope.find(params[:id])
        intention.destroy

        render json: intention,
               serializer: IntentionSerializer::Common,
               root: "data", include: "**"
      end

      # 把几个意向分配给某车商
      def batch_assign
        intention_ids = params[:intention_ids]
        company_id = params[:company_id]

        service = AllianceCompanyService::Intentions::Assign.new(
          current_user, intention_ids, company_id
        )

        service.assign

        if service.valid?
          intentions_scope = Intention.where(company_id: company_id, id: intention_ids)
          render json: intentions_scope.includes(:intention_level, :channel, :assignee),
                 each_serializer: IntentionSerializer::Basic,
                 root: "data", include: "**"
        else
          validation_error(full_errors(service.intention))
        end
      end

      private

      def fetch_intentions(need_paginate)
        basic_params_validations
        param! :order_field, String,
               default: "id",
               in: %w( id due_time )

        scope = Intention
                .select("intentions.*", Intention.order_by_state(true))
                .includes(intention_push_histories: [:intention_level, :executor, { cars: :cover }])
                .where(alliance_company_id: current_company.id)

        order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

        intentions = scope
                     .ransack(params[:query]).result.uniq
                     .order(Intention.order_by_state(true))
                     .order(Intention.order_sql(params[:order_field], order_by))
        need_paginate ? paginate(intentions) : intentions
      end

      def intention_params
        params.require(:intention).permit(
          :customer_name, :customer_phone, { customer_phones: [] }, :gender, :province,
          :city, :intention_type, :assignee_id, :intention_level_id, :channel_id,
          :intention_note, { seeking_cars: [] }, :minimum_price_wan, :maximum_price_wan,
          :brand_name, :series_name, :mileage, :licensed_at, :color, :alliance_state,
          :style_name, :customer_id, :processing_time, :interviewed_time,
          :alliance_intention_level_id
        ).tap do |white_listed|
          if white_listed[:customer_phones].blank?
            white_listed[:customer_phones] = []
          end

          intention = params[:intention]

          return white_listed unless intention && intention.key?(:seeking_cars)

          white_listed[:seeking_cars] = if intention[:seeking_cars].blank?
                                          []
                                        else
                                          intention[:seeking_cars]
                                        end
        end
      end

      def current_company
        current_user.alliance_company
      end

      def intention_scope
        Intention.where(alliance_company_id: current_company.id)
      end
    end
  end
end
