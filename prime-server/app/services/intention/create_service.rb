class Intention < ActiveRecord::Base
  class CreateService
    include ErrorCollector
    attr_reader :intention

    def initialize(user, scope, params)
      @user = user
      @intention = scope.new(params)
      @params = params
    end

    def execute(check_intention: false)
      check_intention && check!

      customer = find_or_init_customer
      begin
        Intention.transaction do
          associate_customer!(customer)

          create_intention!(customer)
          notify_managers
        end
      rescue ActiveRecord::RecordInvalid
        handle_error(customer)
      end

      self
    end

    private

    def check!
      phones = @params[:customer_phones] || []
      phones << @params[:customer_phone]

      Intention::CheckService.new(@user).check!(
        customer_phones: phones,
        customer_id:    @params[:customer_id],
        intention_type: @params[:intention_type]
      )
    end

    def find_or_init_customer
      customer = @user.company.customers.phones_include(@intention.customer_phone).first
      customer = @user.customers.new unless customer
      customer
    end

    def handle_error(customer)
      [:phones, :phone].each do |attr|
        error_message = customer.errors[attr].first
        if error_message.present?
          @intention.errors.add("customer_#{attr}".to_sym, error_message)
        end
      end
    end

    def associate_customer!(customer)
      fallible customer
      customer.assign_attributes(
        company_id: @intention.company_id,
        name:       @intention.customer_name,
        phone:      @intention.customer_phone,
        phones:     @intention.customer_phones,
        user_id:    @intention.assignee_id
      )
      customer.save!
    end

    def create_intention!(customer)
      fallible @intention

      @intention.assign_attributes(
        customer_id: customer.id,
        creator_id: @user.id,
        creator_type: "User",
        shop_id:    @user.shop_id
      )

      @intention.save!
    end

    def notify_managers
      state = @intention.state
      return unless state.in?(%w(untreated pending))

      if @intention.creator_id.nil? && @intention.assignee_id.nil?
        @intention.update(state: "untreated")
      end

      send("create_#{@intention.state}_record")
    end

    def create_untreated_record
      @intention.operation_records.create!(
        user_id: @user.id,
        company_id: @user.company.try(:id),
        operation_record_type: :remind_intention_untreated,
        shop_id: @user.shop_id,
        messages: {
          intention_id: @intention.id,
          intention_type: @intention.intention_type,
          title: "新客户待分配",
          user_name: @user.try(:name),
          customer_name: @intention.customer_name
        },
        user_passport: @user.try(:passport).to_h
      )
    end

    def create_pending_record
      return if @intention.creator_id == @intention.assignee_id

      @intention.operation_records.create!(
        user_id: @user.id,
        company_id: @user.company.try(:id),
        operation_record_type: :intention_reassigned,
        shop_id: @user.shop_id,
        messages: {
          intention_id: @intention.id,
          intention_type: @intention.intention_type,
          title: "新客户待跟进",
          user_name: @user.try(:name),
          customer_name: @intention.customer_name
        },
        user_passport: @user.try(:passport).to_h
      )
    end
  end
end
