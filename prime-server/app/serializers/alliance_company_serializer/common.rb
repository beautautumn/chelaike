module AllianceCompanySerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :contact, :contact_mobile,
               :sale_mobile, :logo, :note, :province, :city,
               :district, :street, :owner_id, :created_at,
               :updated_at, :settings, :deleted_at, :slogan,
               :qrcode, :banners
  end
end
