module RegistrationSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :username, :authorities, :authority_type, :token, :created_at,
               :phone, :name, :avatar, :created_at, :simple_token, :settings,
               :qrcode_url, :self_description

    has_many :authority_roles, serializer: AuthorityRoleSerializer::Common
    belongs_to :company, serializer: CompanySerializer::Common
    belongs_to :shop, serializer: ShopSerializer::Common
  end
end
