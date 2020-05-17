class Intention < ActiveRecord::Base
  class BatchAssignService
    class Manager
      attr_reader :scope

      def initialize(user, intention_ids)
        @user = user
        @scope = Intention.where(company_id: user.company_id, id: intention_ids)
      end

      def execute(assignee_id, processing_time = nil)
        if processing_time.blank?
          without_processing_time(assignee_id)
        else
          with_processing_time(assignee_id, processing_time)
        end
      end

      private

      def with_processing_time(assignee_id, processing_time)
        @scope.each do |intention|
          Intention.transaction do
            intention.update!(state: "processing", assignee_id: assignee_id)

            begin
              IntentionPushHistory::CreateService.new(
                @user, intention,
                intention_push_history_params(processing_time)
              ).execute
            rescue Intention::CheckService::InvalidError
              raise ActiveRecord::Rollback
            end

            intention.notice_new_assigee(@user)
          end
        end
      end

      def without_processing_time(assignee_id)
        Intention.transaction do
          @scope.includes(:assignee).each do |intention|
            if intention.assignee_id.blank? || intention.state.untreated?
              intention.assign_attributes(assignee_id: assignee_id, state: "pending")
            else
              intention.assign_attributes(assignee_id: assignee_id)
            end
            intention.notice_new_assigee(@user)

            intention.save!
          end
        end
      end

      def intention_push_history_params(processing_time)
        {
          state: "processing",
          processing_time: processing_time,
          checked: false,
          note: ""
        }
      end
    end
  end
end
