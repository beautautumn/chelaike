module AllianceDashboardSerializer
  module IntentionSerializer
    class Intention < ::IntentionSerializer::Common
      has_many :intention_push_histories, serializer: IntentionPushHistorySerializer::Common

      def indention_push_histories
        object.indention_push_histories.includes(:intention_level, :executor, cars: [:cover])
      end
    end
  end
end
