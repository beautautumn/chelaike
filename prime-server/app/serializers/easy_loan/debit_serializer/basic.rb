module EasyLoan
  class DebitSerializer::Basic < ActiveModel::Serializer
    attributes :id, :inventory_amount, :operating_health, :industry_rating,
               :assets_debts_rating, :comprehensive_rating,
               :beat_local_percentage, :beat_country_percentage,
               :rating_statements_text

    def comprehensive_rating
      object.comprehensive_rating.to_f.try(:round, 1).to_s
    end
  end
end
