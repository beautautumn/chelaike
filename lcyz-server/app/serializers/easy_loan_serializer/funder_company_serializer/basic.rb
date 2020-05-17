module EasyLoanSerializer
  module FunderCompanySerializer
    class Basic < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
