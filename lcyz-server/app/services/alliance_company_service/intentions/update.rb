module AllianceCompanyService
  module Intentions
    class Update
      include ErrorCollector
      attr_accessor :intention

      def initialize(current_user, intention, intention_params)
        @params = intention_params
        @user = current_user
        @intention = intention
      end

      def update
        begin
          Intention.transaction do
            update_intention!
            update_customer!
          end
        rescue ActiveRecord::RecordInvalid
          handle_error(customer)
        end
        self
      end

      private

      def update_customer!
        customer = @intention.customer

        fallible customer
        customer.update!(
          name: @intention.customer_name,
          phone: @intention.customer_phone,
          phones: @intention.customer_phones,
          user_id: @intention.assignee_id
        )
      end

      # def update_intention!(customer)
      def update_intention!
        fallible @intention
        @intention.assign_attributes(@params)

        @intention.save!
      end

      def find_or_init_customer
        customer = @user.alliance_company.customers.phones_include(@intention.customer_phone).first
        customer = @user.customers.new(
          alliance_company_id: @user.company_id,
          name:       @intention.customer_name,
          phone:      @intention.customer_phone,
          phones:     @intention.customer_phones,
          alliance_user_id:    @user.id
        ) unless customer
        customer
      end
    end # end of class
  end
end
