module FinanceSerializer
  module CarFeeSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :car_id, :creator_id, :category, :item_name,
                 :fee_date, :note, :user_id, :user_name, :amount,
                 :created_at, :updated_at

      def amount
        unit = object.category.in?(%w(payment receipt)) ? "wan" : "yuan"
        object.send("amount_#{unit}")
      end

      def user_name
        object.user.try(:name)
      end
    end
  end
end
