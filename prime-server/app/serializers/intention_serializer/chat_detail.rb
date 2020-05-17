module IntentionSerializer
  class ChatDetail < ActiveModel::Serializer
    attributes :id, :intention_type, :seeking_cars,
               :created_at, :state, :intention_note, :gender,
               :earnest, :assignee_id, :company_name,
               :company_address,
               :minimum_price_wan, :maximum_price_wan,
               :assignee_name, :assignee_phone, :assignee_avatar

    delegate :name, :phone, :avatar, to: :assignee, prefix: true
    delegate :name, :address, to: :company, prefix: true

    delegate :assignee, :company, to: :object

    belongs_to :intention_level, serializer: IntentionLevelSerializer::Common

    def created_at
      Util::Datetime.date_with_time_format(object.created_at)
    end
  end
end
