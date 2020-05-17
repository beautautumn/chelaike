module V1
  class IntentionsController < ApplicationController
    before_action :skip_authorization, except: [:show, :update, :batch_destroy]

    def index
      validate_params
      record_recent_keywords(:intentions)

      intentions = Intention::ListService.new(current_user, params)
                                         .execute.includes(
                                           :intention_level, :channel, :assignee,
                                           :source_company, :source_car, :closing_car,
                                           latest_intention_push_history: [
                                             :intention_level, :executor, :closing_car,
                                             { cars: [:cover] }
                                           ]
                                         )

      assignees = User.where(
        id: intentions.select(:assignee_id).pluck(:assignee_id).uniq
      ).select(:id, :name)

      relative_states = intentions.select(:state).pluck(:state).uniq.compact

      render json: paginate(intentions),
             each_serializer: IntentionSerializer::Common,
             root: "data", include: "**",
             meta: {
               relative_states: relative_states,
               assignees: assignees
             }
    end

    def cars
      basic_params_validations
      param! :order_field, String,
             default: "id",
             in: %w(
               id stock_age_days show_price_cents age
               mileage name_pinyin acquired_at
             )

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"
      params[:order_field] = "acquired_at" if params[:order_field] == "id"

      intention = intention_scope.find(params[:id])

      cars = cars_scope(intention.seeking_cars_condition)
      companies = relative_companies(cars)
      cars = paginate cars
             .ransack(params[:query]).result
             .order("#{params[:order_field]} #{order_by}")
             .order(id: :desc)

      render json: cars.eager_load_bunch_data,
             each_serializer: CarSerializer::Common,
             root: "data",
             meta: { companies: companies }
    end

    def alied_cars
      basic_params_validations
      param! :order_field, String,
             default: "acquired_at",
             in: %w(id show_price_cents age mileage name_pinyin acquired_at)
      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

      intention = intention_scope.find(params[:id])

      cars = alied_cars_scope(intention.seeking_cars_condition)
             .where.not(company_id: current_user.company_id)
      companies = relative_companies(cars)
      data = paginate cars
             .includes(:cover, company: [:alliance_company_relationships])
             .ransack(params[:query]).result
             .order("#{params[:order_field]} #{order_by}").order(:id)

      render json: data,
             each_serializer: CarSerializer::AllianceCarsList,
             root: "data",
             meta: { companies: companies }
    end

    def create
      begin
        service = Intention::CreateService.new(
          current_user, intention_scope, intention_params
        ).execute(check_intention: true)
      rescue Intention::CheckService::InvalidError => e
        return forbidden_error(e.message)
      end

      if service.valid?
        render json: service.intention,
               serializer: IntentionSerializer::Common,
               root: "data", include: "**"
      else
        validation_error(full_errors(service.intention))
      end
    end

    def update
      intention = intention_scope.find(params[:id])
      authorize intention

      begin
        service = Intention::UpdateService.new(
          current_user, intention, intention_params
        ).execute
      rescue Intention::CheckService::InvalidError => e
        return forbidden_error(e.message)
      rescue Intention::UpdateService::ForbiddenActionError => e
        return forbidden_error(e.message)
      end

      if service.valid?
        render json: service.intention,
               serializer: IntentionSerializer::Common,
               root: "data", include: "**"
      else
        validation_error(full_errors(service.intention))
      end
    end

    def show
      intention = intention_scope.find(params[:id])
      authorize intention

      condition = intention.seeking_cars_condition

      render json: intention,
             serializer: IntentionSerializer::Detail,
             root: "data",
             include: "**",
             meta: {
               cars_count: cars_scope(condition).size,
               alied_cars_count: alied_cars_scope(condition).size
             }
    end

    # 发送到聊天前先告知server
    def send_chat
      intention = Intention.find(params[:id])
      intention.update(assignee: current_user) if intention.assignee.blank?
      render json: { data: "ok" }
    end

    def chat_detail
      intention = Intention.find(params[:id])

      render json: intention,
             serializer: IntentionSerializer::ChatDetail,
             root: "data"
    end

    def check
      intention_params = {
        customer_phones: params[:phone],
        customer_id: params[:customer_id],
        intention_type: params[:type]
      }

      begin
        Intention::CheckService.new(
          current_user, agency: params[:type].present?
        ).check!(intention_params)
      rescue Intention::CheckService::InvalidError => e
        return forbidden_error(e.message)
      end

      render json: { data: { check: true } }, scope: nil
    end

    def import
      record = ImportTask.create!(
        user_id: current_user.id,
        company_id: current_user.company_id,
        import_task_type: :intention
      )

      service = Intention::ImportService.new(record)

      begin
        service.ready_to_execute(params[:file])

        render json: { message: :ok }, scope: nil
      rescue Intention::ImportService::FileInvalid => e
        validation_error(e.message)
      rescue
        validation_error("文件格式无法解析, 请使用 xls格式Excel")
      end
    end

    def batch_assign
      param! :intention_ids, Array, required: true
      param! :assignee_id, Integer, required: true

      service = Intention::BatchAssignService::Manager.new(
        current_user, params[:intention_ids]
      )

      service.execute(params[:assignee_id], params[:processing_time])

      render json: service.scope.includes(:intention_level, :channel, :assignee),
             each_serializer: IntentionSerializer::Basic,
             root: "data", include: "**"
    end

    def batch_destroy
      authorize Intention, :destroy?
      param! :intention_ids, Array, required: true

      intention_scope.where(id: params[:intention_ids]).update_all(deleted_at: Time.zone.now)

      render json: { data: params[:intention_ids] }, scope: nil
    end

    def share
      intention = intention_scope.find(params[:id])
      shared_user_ids = params[:shared_users]
      authorize intention

      service = Intention::ShareService.new(intention)

      begin
        service.share_to(shared_user_ids)
        render json: intention,
               serializer: IntentionSerializer::Detail,
               root: "data",
               include: "**"
      rescue Intention::ShareService::NoAssigneeError => e
        validation_error(e.message)
      end
    end

    def to_be_recycled
      validate_params
      intentions = Intention::RecycleService.new(current_user, params)
                                            .list.includes(
                                              :intention_level, :channel, :assignee,
                                              :source_company, :source_car, :closing_car,
                                              latest_intention_push_history: [
                                                :intention_level, :executor, :closing_car,
                                                { cars: [:cover] }
                                              ]
                                            )

      assignees = User.where(
        id: intentions.select(:assignee_id).pluck(:assignee_id).uniq
      ).select(:id, :name)

      relative_states = intentions.select(:state).pluck(:state).uniq.compact

      render json: paginate(intentions),
             each_serializer: IntentionSerializer::Common,
             root: "data", include: "**",
             meta: {
               relative_states: relative_states,
               assignees: assignees
             }
    rescue Intention::RecycleService::NoExpirationSetError
      # 如果不设置过期时间, 禁用此功能
      return render json: { data: [] }, scope: nil
    end

    def recycle
      param! :intention_ids, Array, required: true
      service = Intention::RecycleService.new(current_user, params)

      render json: { data: service.recycle }, scope: nil
    rescue Intention::RecycleService::NoExpirationSetError
      # 如果不设置过期时间, 禁用此功能
      return render json: { data: [] }, scope: nil
    end

    private

    def intention_params
      params.require(:intention).permit(
        :customer_name, :customer_phone, { customer_phones: [] }, :gender, :province,
        :city, :intention_type, :assignee_id, :intention_level_id, :channel_id,
        :intention_note, { seeking_cars: [] }, :minimum_price_wan, :maximum_price_wan,
        :brand_name, :series_name, :mileage, :licensed_at, :color, :state, :earnest,
        :style_name, :customer_id, :processing_time, :interviewed_time, :consigned_at,
        :annual_inspection_notify_date, :insurance_notify_date, :mortgage_notify_date,
        :after_sale_assignee_id
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

    def validate_params
      basic_params_validations

      param! :order_field, String, default: "due_time", in: %w(id due_time)
      param! :task_type, String, in: %w(
        pending_interviewing_task_today pending_processing_task_today
        expired_interviewed_task_today expired_processed_task_today
      )
      param! :task_statistic_type, String, in: %w(
        intention_interviewed intention_processed intention_completed intention_failed
      )
      param! :task_statistic_scope, String, in: %w(today current_month), default: "today"
      param! :task_statistic_intention_type, String, in: %w(seek sale)
      param! :user_ids, String
      param! :expired, :boolean
      param! :daily_management_user, String,
             in: DailyManagement::BaseService::GROUPS.keys.map(&:to_s)
      param! :daily_management_type, String, in: %w(
        untreated_intentions pending_intentions
        pending_dealing_intentions expired_dealing_intentions waiting_recycle_intentions
        unfinished_intentions finished_intentions
        intentions
      )
    end

    def relative_companies(cars)
      return [] unless params[:need_companies]

      company_ids = cars.pluck(:company_id).uniq.compact
      Company.where(id: company_ids)
             .select(:id, :name, :logo, :active_tag,
                     :honesty_tag, :honesty_tag, :own_brand_tag
                    )
    end

    def intention_scope
      Intention.intention_scope(current_user.company_id)
    end

    def cars_scope(condition)
      car_policy_scope(current_user.company.cars)
        .state_in_stock_scope
        .where(reserved: false)
        .where(condition)
    end

    def alied_cars_scope(condition)
      current_user.company.allied_cars
                  .state_in_stock_scope
                  .where(reserved: false)
                  .where(condition)
    end

    def car_policy_scope(scope)
      CarPolicy::Scope.new(current_user, scope).resolve
    end
  end
end
