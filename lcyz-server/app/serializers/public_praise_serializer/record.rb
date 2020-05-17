module PublicPraiseSerializer
  class Record < ActiveModel::Serializer
    attributes :id, :link, :level, :logo, :username, :content, :most_satisfied, :least_satisfied
  end
end
