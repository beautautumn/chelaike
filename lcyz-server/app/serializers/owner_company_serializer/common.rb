module OwnerCompanySerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :shop_name, :shop_id, :updated_at, :created_at

    def updated_at
      formated_date(object.updated_at)
    end

    def created_at
      formated_date(object.created_at)
    end

    def formated_date(date)
      date.strftime("%Y.%m.%d")
    end
  end
end
