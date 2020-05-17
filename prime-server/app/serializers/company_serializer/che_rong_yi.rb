module CompanySerializer
  class CheRongYi < ActiveModel::Serializer
    attributes :id, :name, :address, :company_id, :created_at, :phone,
               :contact_user_name, :province, :city, :district, :street,
               :logo

    def phone
      object.contact_mobile
    end

    def contact_user_name
      object.contact
    end

    def company_id
      object.id
    end
  end
end
