module AllianceDashboardSerializer
  module CompanySerializer
    class Alliance < ActiveModel::Serializer
      attributes :id, :name, :logo, :nickname,
                 :contact, :contact_mobile, :note, :street,
                 :joined_at

      delegate :joined_at, :contact, :contact_mobile, :street, to: :relationship

      def joined_at
        relationship.created_at
      end

      private

      def alliance
        instance_options[:alliance] || Alliance.new
      end

      def relationship
        alliance_id = alliance && alliance.id
        @_relationship ||= AllianceCompanyRelationship.where(
          company_id: object.id,
          alliance_id: alliance_id).first
      end
    end
  end
end
