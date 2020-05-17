module ChatSerializer
  module Alliance
    class WithCompanies < ActiveModel::Serializer
      attributes :id, :name, :avatar, :companies_count, :created_at,
                 :honesty_tag, :own_brand_tag, :active_tag

      has_many :companies, serializer: ChatSerializer::Company::WithUsers
    end
  end
end
