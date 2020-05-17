class Intention < ActiveRecord::Base
  class ReserveAssociateService < AssociateService
    def cancel_reservation
      @customer = find_or_init_customer
      return unless @customer.id

      @intention = find_or_init_intention(@customer)
      return unless @intention

      push_intention(@intention)
    end

    protected

    def find_or_init_intention(customer)
      find_params = {
        customer_id: customer.id,
        intention_type: "seek"
      }

      Intention.state_unfinished_scope
               .create_with(intention_params(customer))
               .find_or_initialize_by(find_params)
    end

    def update_intention!(intention)
      fallible intention

      if intention.persisted?
        intention.channel_id = @customer_params[:customer_channel_id]
      end
      intention.save!
    end
  end
end
