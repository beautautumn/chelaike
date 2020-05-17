# rubocop:disable all
module Che3bao
  class CustomerMigrationService
    def initialize(corp_id, company_id)
      @corp_id = corp_id
      @company_id = company_id
    end

    def execute(range = nil)
      ActiveRecord::Base.uncached do
        import_customer_levels
        import_customers(customers(range))
      end
    end

    def customers(range)
      return Customer.where(cust_id: range, owner_corp: @corp_id) if range

      Customer.where(owner_corp: @corp_id)
    end

    def customers_count(range)
      customers(range).size
    end

    def import_customers(scope)
      scope.where("valid_tag = 1").includes(
        :staff, :creator, :intention_push_histories, { region: :parent },
        :channel, sale_intention: :sale_intention_cars
      ).find_in_batches(batch_size: 50) do |group|
        # ObjectSpace.each_object(ActiveRecord::Relation).each(&:reset)
        # GC.start

        group.each do |customer|
          user_id = find_user_by_name(customer.staff.try(:login_name)).try(:id)
          histories = customer.intention_push_histories.sort_by(&:follow_his_id)

          new_customer = create_customer(@company_id, customer, user_id)

          import_intentions(customer, new_customer, histories)
        end
      end
    end

    def create_customer(company_id, customer, user_id)
      new_customer = ::Customer.new
      new_customer.assign_attributes(
        company_id: company_id,
        name: customer.cust_name,
        note: customer.note,
        phone: customer.phone_number,
        gender: customer.sex,
        created_at: customer.create_time,
        updated_at: customer.update_time,
        id_number: customer.id_no,
        user_id: user_id
      )
      new_customer.save(validate: false)
      new_customer
    end

    def import_intentions(customer, new_customer, histories)
      conversations = cleanup_conversations(histories)
      conversations_size = conversations.size

      conversations.each_with_index do |intention_histories, index|
        params = intention_shared_params(customer, new_customer)

        if conversations_size == index + 1
          params[:state] = customer.state
        else
          params[:state] = intention_histories.last.try(:state)
        end

        due_time = customer.intention_push_history.try(:plan_follow_date)

        if customer.state == "interviewed"
          params[:interviewed_time] = due_time
        else
          params[:processing_time] = due_time
        end

        ActiveRecord::Base.transaction do
          intention = create_intention(customer, params)

          create_histories(intention_histories, intention.id, intention.assignee_id)
        end
      end
    end

    def cleanup_conversations(histories)
      initial_id = 0
      conversations = []
      arr = []

      histories.each_with_index do |history, index|
        if history.follow_his_id > initial_id && %w(ycj ysk yzb).include?(history.follow_result)
          initial_id = history.follow_his_id

          arr = arr + [history]
          conversations = conversations + [arr]

          arr = []
        else
          arr = arr + [history]
        end

        conversations = conversations + [arr] if histories.size == index + 1
      end

      conversations
    end

    def intention_shared_params(customer, new_customer)
      {
        customer_id: new_customer.id,
        customer_name: new_customer.name,
        creator_id: find_user_by_name(customer.creator.try(:login_name)).try(:id),
        assignee_id: find_user_by_name(customer.staff.try(:login_name)).try(:id),
        province: customer.region.try(:parent).try(:name),
        city: customer.region.try(:name),
        intention_level_id: customer.customer_level.try(:appropriate_id),
        channel_id: ::Channel.find_by(
          company_id: @company_id, name: customer.try(:channel).try(:source_name)
        ).try(:id),
        created_at: customer.create_time,
        updated_at: customer.update_time,
        shop_id: find_user_by_name(customer.staff.try(:login_name)).try(:shop_id),
        customer_phone: customer.phone_number,
        gender: customer.sex
      }
    end

    def create_intention(customer, intention_base_params)
      if customer.intention_type == "seek"
        sale_intention = customer.sale_intention

        if sale_intention.try(:sale_intention_cars).present?
          seeking_cars = sale_intention.sale_intention_cars
                         .map { |car| { brand_name: car.brand_name, series_name: car.series_name } }
        else
          seeking_cars = []
        end

        intention = Intention.new(
          intention_base_params.merge(
            company_id: @company_id,
            intention_type: "seek",
            seeking_cars: seeking_cars,
            intention_note: sale_intention.try(:other_desc),
            minimum_price_cents: sale_intention.try(:low_desire_price),
            maximum_price_cents: sale_intention.try(:high_desire_price)
          )
        )
      else
        acquisition_intention = customer.acquisition_intention

        intention = Intention.new(
          intention_base_params.merge(
            company_id: @company_id,
            intention_type: "sale",
            brand_name: acquisition_intention.try(:brand_name),
            series_name: acquisition_intention.try(:series_name),
            style_name: acquisition_intention.try { |i| i.read_attribute(:model_name) },
            color: acquisition_intention.try(:car_color),
            mileage: acquisition_intention.try(:mileage_count).try { |m| m / 10_000 },
            licensed_at: Util::Date.parse_date_string(acquisition_intention.try(:regist_month)),
            intention_note: acquisition_intention.try(:other_desc),
            minimum_price_cents: acquisition_intention.try(:intend_price),
            maximum_price_cents: acquisition_intention.try(:intend_price)
          )
        )
      end

      intention.save(validate: false)
      intention
    end

    def create_histories(histories, intention_id, assignee_id)
      histories.each do |history|
        next if history.state == "pending"

        params = {
          state: history.state,
          created_at: history.follow_time,
          updated_at: history.update_time,
          checked: false,
          note: history.follow_desc,
          executor_id: assignee_id
        }

        due_time = history.next_follow_date.try { |date| date.to_time(:utc) }

        if history.state == "interviewed"
          params[:interviewed_time] = due_time
        else
          params[:processing_time] = due_time
        end

        ::IntentionPushHistory.create!(params.merge(intention_id: intention_id))
      end
    end

    def import_customer_levels
      CustomerLevel.where(corp_id: @corp_id, valid_tag: 1).each do |customer_level|
        intention_level = IntentionLevel.new(
          company_id: @company_id,
          name: customer_level.level_name,
          created_at: customer_level.create_time
        )
        intention_level.save(validate: false)

        customer_level.appropriate = intention_level
      end
    end

    def find_user_by_name(username)
      return unless username.present?

      key = "customer_migration_#{@company_id}_#{username}"

      Rails.cache.fetch(Digest::MD5.hexdigest(key)) do
        User.find_by(company_id: @company_id, username: username)
      end
    end

    def cleanup
      company = Company.find(@company_id)

      company.intention_levels.delete_all
      company.customers.delete_all
      company.intentions.each(&:really_destroy!)
    end
  end
end
# rubocop:enable all
