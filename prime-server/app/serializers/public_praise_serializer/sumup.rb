module PublicPraiseSerializer
  class Sumup < ActiveModel::Serializer
    attributes :id, :sumup, :quality_problems

    has_one :recommendation_record, serializer: PublicPraiseSerializer::Record
  end
end
