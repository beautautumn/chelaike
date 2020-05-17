class Intention < ActiveRecord::Base
  class CheckService
    class ErrorMessage
      def self.no_customers
        I18n.t("service.intention.check_service.error_messages.no_customers")
      end

      def self.occupied(intention)
        I18n.t(
          "service.intention.check_service.error_messages.occupied",
          customer_name: intention.customer_name,
          customer_phone: intention.customer_phone,
          intention_type: intention.intention_type_text,
          assignee_name: intention.assignee.try(:name)
        )
      end

      def self.processing
        I18n.t("service.intention.check_service.error_messages.processing")
      end

      def self.duplicated(intention)
        I18n.t(
          "service.intention.check_service.error_messages.duplicated",
          customer_name: intention.customer_name,
          customer_phone: intention.customer_phone,
          assignee_name: intention.assignee.try(:name)
        )
      end
    end

    class InvalidError < StandardError; end

    attr_reader :error_message, :intention

    def initialize(current_user, agency: false)
      @current_user = current_user
      @agency = agency
    end

    def check!(intention_params)
      intentions = find_intention(intention_params)

      return if intentions.blank?

      intentions.each do |intention|
        next if seek_checkout(intention)
        raise InvalidError, generate_error_message(intention, intention_params[:customer_phones])
      end
    end

    private

    def own_customer?(customer_phones)
      @current_user.can?("代办客户预定/出库") ||
        @current_user.customers.phones_include(customer_phones).present?
    end

    def generate_error_message(intention, customer_phones)
      if @agency
        if own_customer?(customer_phones)
          ErrorMessage.occupied(intention)
        else
          ErrorMessage.no_customers
        end
      elsif intention.assignee_id == @current_user.id
        ErrorMessage.processing
      else
        ErrorMessage.duplicated(intention)
      end
    end

    def find_intention(params)
      intentions = if params[:customer_id]
                     intention_scope.where(customer_id: params[:customer_id])
                   else
                     intention_scope.phones_include(params[:customer_phones])
                   end

      if params[:intention_type]
        intentions = intentions.where(intention_type: params[:intention_type])
      end

      intentions.state_unfinished_scope
    end

    def intention_scope
      @current_user.company.intentions
    end

    def seeking_message(intention)
      intention.seeking_cars.map do |car|
        message = "#{car.brand_name} #{car.series_name}"
        case
        when intention.minimum_price_wan && intention.maximum_price_wan
          message << ",预算: #{intention.minimum_price_wan}-#{intention.maximum_price_wan}万"
        when car.minimum_price_wan
          message << ",预算: #{intention.minimum_price_wan}万"
        when car.maximum_price_wan
          message << ",预算: #{intention.maximum_price_wan}万"
        end

        message
      end.join(";")
    end

    def seek_checkout(intention)
      @agency && (
        @current_user.can?("代办客户预定/出库") ||
        !intention.assignee.present? ||
        intention.assignee_id == @current_user.id
      )
    end
  end
end
