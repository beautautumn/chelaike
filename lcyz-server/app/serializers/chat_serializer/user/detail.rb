module ChatSerializer
  module User
    class Detail < ChatSerializer::User::Basic
      attributes :is_top, :is_blocked

      delegate :is_top, :is_blocked, to: :conversation

      def conversation
        @_conversation = instance_options[:conversation]
      end
    end
  end
end
