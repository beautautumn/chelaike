module CarSerializer
  class BmReport < ActiveModel::Serializer
    include CarSerializer::Concern

    attributes :shop_city, :shop_name, :acquirer_name, :owner_company_name,
               :company_name, :sales_type

    def shop_city
      object.shop.try(:city)
    end

    def shop_name
      object.shop.try(:name)
    end

    def acquirer_name
      object.acquirer.try(:name)
    end

    def owner_company_name
      object.owner_company.try(:name)
    end

    def company_name
      object.company.name
    end

    def sales_type
      return "-" unless object.stock_out_inventory
      object.stock_out_inventory.try(:sales_type_text)
    end
  end
end
