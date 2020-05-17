module AcquisitionCarInfoSerializer
  class Info < ActiveModel::Serializer
    attributes :id, :brand_name, :series_name, :style_name,
               :acquirer_id, :company_id, :company_name,
               :licensed_at, :new_car_guide_price_wan,
               :new_car_final_price_wan, :manufactured_at, :mileage,
               :exterior_color, :interior_color, :displacement,
               :prepare_estimated_yuan, :manufacturer_configuration,
               :valuation_wan, :state, :created_at, :updated_at,
               :note_text, :key_count, :images, :owner_info,
               :is_turbo_charger, :note_audios, :configuration_note,
               :procedure_items, :license_info, :acquirer_name,
               :closing_cost_wan, :car_id

    attribute :cooperates, if: :cooperates?
    attribute :seller_user, if: :cooperates?
    attribute :intention_level, if: :with_intention?
    attribute :expected_wan, if: :with_intention?

    has_many :comments, serializer: AcquisitionCarCommentSerializer::Basic

    def cooperates?
      instance_options[:cooperates]
    end

    def with_intention?
      instance_options[:with_intention]
    end

    def intention_level
      object.owner_intention.intention_level.fetch("name", "")
    end

    def expected_wan
      object.owner_intention.expected_price_wan
    end
  end
end
