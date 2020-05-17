class Intention < ActiveRecord::Base
  class UpdateService
    class ForbiddenActionError < StandardError; end

    include ErrorCollector

    attr_reader :intention

    def initialize(user, intention, params)
      @user = user
      @intention = intention
      @params = params
    end

    def execute
      check!
      fallible @intention

      begin
        ActiveRecord::Base.connection.transaction do
          @intention.assign_attributes(@params)
          @intention.notice_new_assigee(@user)

          process_alliance_attr

          # 处理到期提醒字段
          process_notifications

          @intention.save!

          customer_sync(@intention.customer)
          update_reservation(@intention.customer)
        end
      rescue ActiveRecord::RecordInvalid
        handle_error
        @intention
      end

      self
    end

    def handle_error
      return unless @customer.errors[:phones]
      @intention.errors.add(:customer_phone, @customer.errors[:phones].first)
    end

    def customer_sync(customer)
      return if customer.blank?

      @customer = customer
      fallible @customer

      @customer.update!(
        name: @intention.customer_name,
        phone: @intention.customer_phone,
        phones: @intention.customer_phones,
        user_id: @intention.assignee_id
      )
    end

    def update_reservation(customer)
      return if customer.blank?
      return unless @intention.state.reserved?

      reservation = CarReservation.find_by(customer_id: @customer.id)
      reservation.update!(customer_channel_id: @intention.channel_id) if reservation
    end

    private

    # 处理从官网来的意向，在分配时，设置联盟公司ID
    def process_alliance_attr
      return if intention.alliance_company_id.present? ||
                @params[:assignee_id].blank?
      company = intention.company
      return unless company.alliance_manager
      @intention.assign_attributes(alliance_company_id: company.alliance_manager_id)
    end

    # 处理到期提醒字段
    def process_notifications
      service = ExpirationNotificationService::Intention.new(@intention, @user)
      service.execute
    end

    def check!
      raise ForbiddenActionError, "没有操作权限" unless operate_authority?

      raise ForbiddenActionError, "没有权限更改归属人" if cannot_change_assignee

      return if @params[:customer_phone] == @intention.customer.phone

      check_intention!
    end

    def check_intention!
      customer_check_params = if customer_phone_changed?
                                { customer_phones: [@params[:customer_phone]] }
                              else
                                { customer_id: @params[:customer_id] }
                              end
      Intention::CheckService.new(@user).check!(
        { intention_type: intention.intention_type }.merge(customer_check_params)
      )
    end

    def user_is_manager?
      @user.business_manager?(@intention.intention_type)
    end

    def assignee_changed?
      return unless @params.key?(:assignee_id)
      @params[:assignee_id].try(:to_i) != @intention.assignee_id
    end

    def customer_phone_changed?
      @params[:customer_phone] != @intention.customer.phone
    end

    def operate_authority?
      user_is_manager? || @intention.assignee_id == @user.id
    end

    def cannot_change_assignee
      (!user_is_manager? && assignee_changed?)
    end
  end
end
