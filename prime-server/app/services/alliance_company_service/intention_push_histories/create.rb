module AllianceCompanyService
  module IntentionPushHistories
    class Create
      include ErrorCollector

      attr_accessor :intention_push_history

      def initialize(current_user, intention, push_history_params)
        @user = current_user
        @intention = intention
        @intention_push_history = @intention.intention_push_histories.new(
          type: "AllianceIntentionPushHistory"
        )
        @params = push_history_params.tap do |hash|
          hash[:executor_id] = current_user.id

          if hash[:state] == "interviewed"
            hash[:processing_time] = nil
          else
            hash[:interviewed_time] = nil
          end
        end
      end

      def execute
        fallible @intention, @intention_push_history

        begin
          Intention.transaction do
            seek_intention
          end

        rescue ActiveRecord::RecordInvalid
          @intention
        end

        self
      end

      private

      def seek_intention
        @intention_push_history.attributes = @params.except(
          :car_ids, :estimated_price_wan, :intention_type
        )

        @intention_push_history.save!

        handle_cars

        update_intention!(shared_attributes)
      end

      def handle_cars
        car_ids = @params.fetch(:car_ids, [])

        return if car_ids.blank?

        car_ids.each do |car_id|
          @intention_push_history.intention_push_cars.create!(
            car_id: car_id,
            intention_id: @intention.id
          )
        end
      end

      def shared_attributes
        %i(
          interviewed_time processing_time state intention_level_id
          deposit_wan closing_cost_wan closing_car_id closing_car_name
        )
      end

      def update_intention!(attributes)
        updated_values = @params.dup.extract!(*attributes)
        updated_values.merge!(alliance_state: updated_values.fetch(:state))
                      .except!(:state)

        @intention.assign_attributes(updated_values)

        @intention.save!
      end
    end
  end
end
