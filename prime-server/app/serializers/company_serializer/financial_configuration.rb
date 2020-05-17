module CompanySerializer
  class FinancialConfiguration < ActiveModel::Serializer
    attributes :fund_rate, :fund_total_wan, :fund_by_company, :rent_by,
               :rent, :area, :gearing
  end
end
