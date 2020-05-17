module AllianceCompanyService
  module Intentions
    class Create
      include ErrorCollector
      attr_accessor :intention

      def initialize(current_user, intention_params)
        @params = intention_params
        @user = current_user
        @intention = Intention.new(intention_params)
      end

      def create
        begin
          Intention.transaction do
            customer = associate_customer!
            create_intention!(customer)
          end
        rescue ActiveRecord::RecordInvalid
          handle_error(customer)
        end
        self
      end

      private

      def associate_customer!
        customer = find_or_init_customer

        fallible customer
        customer.save!
        customer
      end

      def create_intention!(customer)
        fallible @intention
        intention_attributes = {
          customer_id: customer.id,
          creator: @user,
          alliance_assignee: @user,
          alliance_company_id: @user.company_id
        }

        @intention.assign_attributes(
          intention_attributes
        )

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
