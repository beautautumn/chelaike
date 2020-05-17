# == Schema Information
#
# Table name: cooperation_company_relationships # 合作商家关联表
#
#  id                      :integer          not null, primary key # 合作商家关联表
#  car_id                  :integer                                # 车辆ID
#  cooperation_company_id  :integer                                # 合作商家ID
#  cooperation_price_cents :integer                                # 合作价格
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

module CooperationCompanyRelationshipSerializer
  module Common
    extend ActiveSupport::Concern

    included do
      attribute :cooperation_company_relationships
    end

    def cooperation_company_relationships
      authority = scope.can?("合作信息查看") || object.acquirer_id == scope.id

      if authority
        object.cooperation_company_relationships.eager_load(:cooperation_company)
              .map do |relationship|
          cooperation_company = relationship.cooperation_company
          next if cooperation_company.blank?

          attributes = cooperation_company_relationship_attributes(relationship, authority)

          attributes.tap do |result|
            result[:cooperation_company] = {
              id: cooperation_company.id,
              name: cooperation_company.name,
              company_id: cooperation_company.company_id,
              created_at: cooperation_company.created_at
            }
          end
        end.compact
      else
        object.cooperation_company_relationships.map do |relationship|
          cooperation_company_relationship_attributes(relationship, authority)
        end
      end
    end

    def cooperation_company_relationship_attributes(relationship, authority)
      {
        id: relationship.id,
        car_id: relationship.car_id,
        cooperation_company_id: relationship.cooperation_company_id,
        cooperation_company: {
          id: relationship.cooperation_company_id
        }
      }.tap do |hash|
        hash[:cooperation_price_wan] = relationship.cooperation_price_wan if authority
      end
    end
  end
end
