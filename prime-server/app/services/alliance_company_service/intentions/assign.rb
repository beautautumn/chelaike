module AllianceCompanyService
  module Intentions
    class Assign
      include ErrorCollector
      attr_accessor :intention

      def initialize(current_user, intention_ids, company_id)
        @user = current_user
        @intentions = Intention.where(id: intention_ids)
        @company = Company.find(company_id)
      end

      def assign
        @intentions.each do |intention|
          intention.transaction do
            intention.update!(company_id: @company.id,
                              alliance_assigned_at: Time.zone.now,
                              state: "untreated",
                              assignee_id: nil
                             )
            associate_customer(intention)
          end
        end
      end

      private

      def associate_customer(intention)
        alliance_customer = intention.customer
        customer = @company.customers.phones_include(intention.customer_phone).first

        if customer
          fallible customer
          customer.update!(
            name:   alliance_customer.name,
            phone:  alliance_customer.phone,
            phones: alliance_customer.phones,
            note: alliance_customer.note
          )

          intention.update!(customer_id: customer.id)
        else
          fallible alliance_customer
          alliance_customer.update!(company_id: @company.id)
        end
      end
    end
  end
end
