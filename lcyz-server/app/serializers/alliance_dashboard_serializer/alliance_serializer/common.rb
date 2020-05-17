module AllianceDashboardSerializer
  module AllianceSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :name, :avatar, :note, :companies_count, :cars_count,
                 :created_at, :honesty_tag, :own_brand_tag, :active_tag,
                 :contact_mobile, :contact, :city, :province, :district,
                 :street, :water_mark_position, :water_mark

      delegate :contact, :contact_mobile,
               :city, :province, :district, :street,
               :water_mark, :water_mark_position,
               to: :alliance_company

      private

      def alliance_company
        instance_options[:alliance_company]
      end
    end
  end
end
