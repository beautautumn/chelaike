class IntentionPushHistory < ActiveRecord::Base
  class CreateService
    include ErrorCollector

    attr_reader :intention, :intention_push_history

    def initialize(current_user, intention, params)
      @intention = intention
      @intention_push_history = @intention.intention_push_histories.new
      @params = params.tap do |hash|
        hash[:executor_id] = current_user.id

        if hash[:state] == "interviewed"
          hash[:processing_time] = nil
        else
          hash[:interviewed_time] = nil
        end
      end
      @user = current_user
    end

    def execute(options = {})
      check!
      fallible @intention, @intention_push_history

      begin
        record_task_finished
        Intention.transaction { send("#{@intention.intention_type}_intention", options) }

        task_statistic
      rescue ActiveRecord::RecordInvalid
        @intention
      end

      self
    end

    private

    def check!
      if @intention.in_state_finished?
        Intention::CheckService.new(@user, agency: true).check!(
          customer_id:    @intention.customer_id,
          intention_type: @intention.intention_type
        )
      end
    end

    def sale_intention(options)
      @intention_push_history.attributes = @params
      update_checked_info
      sync_stock_out_inventory unless options[:prevent_syncing_stock_out_inventory]

      @intention_push_history.save!

      update_intention!(shared_attributes.push(:estimated_price_wan))
    end

    def seek_intention(options)
      @intention_push_history.attributes = @params.except(
        :car_ids, :estimated_price_wan
      )
      update_checked_info
      sync_stock_out_inventory unless options[:prevent_syncing_stock_out_inventory]

      @intention_push_history.save!

      @params.fetch(:car_ids, []).each do |car_id|
        @intention_push_history.intention_push_cars.create!(
          car_id: car_id,
          intention_id: @intention.id
        )
      end

      update_intention!(shared_attributes)
    end

    def shared_attributes
      %i(
        interviewed_time processing_time state intention_level_id
        deposit_wan closing_cost_wan closing_car_id closing_car_name
      )
    end

    def update_intention!(attributes)
      @intention.assign_attributes(@params.dup.extract!(*attributes))

      @intention.assignee = @user if @intention.assignee.blank?

      if @params.deep_symbolize_keys.fetch(:closing_car_id, "").present?
        @intention.after_sale_assignee_id = @intention.assignee_id
      end

      @intention.save!
    end

    def sync_stock_out_inventory
      return if @intention_push_history.closing_car_id.blank?

      car = @intention_push_history.closing_car

      stock_out_inventory = car.find_or_init_stock_out_inventory
      stock_out_inventory.assign_attributes(
        stock_out_inventory_type: "sold",
        sales_type: "retail",
        seller_id: @user.id,
        completed_at: @intention_push_history.processing_time,
        deposit_wan: @intention_push_history.deposit_wan,
        closing_cost_wan: @intention_push_history.closing_cost_wan,
        customer_name: @intention.customer_name,
        customer_phone: @intention.customer_phone,
        customer_idcard: @intention.customer.id_number,
        customer_channel_id: @intention.channel_id,
        customer_location_province: @intention.province,
        customer_location_city: @intention.city,
        customer_id: @intention.customer_id,
        current: true
      )
      stock_out_inventory.set_remaining_money

      stock_out_inventory.save(validate: false)
    end

    # 如果带跟进为今天, 计算到待跟进已经完成中
    def record_task_finished
      column = task_finished_column
      return if @intention.assignee.blank? || column.blank?

      TaskStatistic.increment(column, @intention.assignee, @intention.id)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def task_finished_column
      midnight = Time.zone.now.midnight
      interviewed_time = @intention.interviewed_time
      processing_time = @intention.processing_time

      case
      when interviewed_time.try(:today?)
        :pending_interviewing_finished
      when processing_time.try(:today?)
        :pending_processing_finished
      when interviewed_time.present? && interviewed_time < midnight
        :expired_interviewed_finished
      when processing_time.present? && processing_time < midnight
        :expired_processed_finished
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def task_statistic
      column = task_statistic_column
      return if @intention.assignee.blank? || column.blank?

      TaskStatistic.increment(column, @intention.assignee, @intention.id)
    end

    def task_statistic_column
      case
      when @intention_push_history.checked # 接待成功
        :intention_interviewed
      when @intention.in_state_unfinished? # 跟进成功
        :intention_processed
      when @intention.in_state_completed? # 已经完成
        :intention_completed
      when @intention.state == "invalid" # 已经失效
        :intention_invalid
      when @intention.state == "failed" # 已经战败
        :intention_failed
      end
    end

    def update_checked_info
      return unless @intention_push_history.checked

      @intention.increment(:checked_count)
      @intention.in_shop_at = Time.zone.now
      @intention_push_history.checked_count = @intention.checked_count
    end
  end
end
