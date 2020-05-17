module StockOutInventorySerializer
  class BmReport < ActiveModel::Serializer
    attributes :id, :shop_city, :shop_name, :seller_name,
               :company_name, :company_shop_name,
               :created_at, :car_brand_name, :car_series_name, :car_exterior_color,
               :car_age, :car_mileage, :car_displacement_text, :car_show_price_wan,
               :car_licensed_at, :customer_name, :customer_phone, :customer_channel_name,
               :customer_created_at, :customer_push_history_days,
               :mortgaged, :mortgage_company_name

    def car
      object.car
    end

    def car_shop
      car.shop
    end

    def customer
      object.customer
    end

    def mortgaged
      object.mortgaged?
    end

    def shop_city
      car_shop.try(:city)
    end

    def shop_name
      car_shop.try(:name)
    end

    def seller_name
      object.seller.try(:name)
    end

    def company_name
      car.owner_company.try(:name)
    end

    def company_shop_name
      car.owner_company.try(:shop).try(:name)
    end

    def car_brand_name
      car.brand_name
    end

    def car_series_name
      car.series_name
    end

    def car_exterior_color
      car.exterior_color
    end

    def car_age
      car.age
    end

    def car_mileage
      car.mileage
    end

    def car_displacement_text
      car.displacement_text
    end

    def car_show_price_wan
      car.show_price_wan
    end

    def car_licensed_at
      car.licensed_at
    end

    def customer_name
      object.customer_name
    end

    def customer_phone
      object.customer_phone
    end

    def customer_channel_name
      object.customer_channel.try(:name)
    end

    def customer_created_at
      customer.try(:created_at)
    end

    def mortgage_company_name
      object.mortgage_company.try(:name)
    end

    def customer_push_history_days
      return "-" unless customer
      latest_seek_intention = customer.intentions.where(intention_type: :seek).last
      return "-" unless latest_seek_intention
      return "-" unless latest_seek_intention.latest_intention_push_history
      latest_push_date = latest_seek_intention.latest_intention_push_history.created_at.to_date
      (object.created_at.to_date - latest_push_date).to_i
    end
  end
end
