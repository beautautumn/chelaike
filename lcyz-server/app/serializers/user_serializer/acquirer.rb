module UserSerializer
  class Acquirer < ActiveModel::Serializer
    include SerializerAuthorityHelper

    attributes :id, :phone, :authority_type, :authorities, :created_at, :email, :first_letter

    attribute :name, if: :acquisition_info?

    def acquisition_info?
      object.id == scope.id || authority_filter("收购信息查看")
    end
  end
end
