module PublicPraiseSerializer
  class OpenSumup < ActiveModel::Serializer
    attributes :id, :sumup, :quality_problems
  end
end
