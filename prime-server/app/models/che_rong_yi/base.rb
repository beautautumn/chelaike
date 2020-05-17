module CheRongYi
  class Base
    include Virtus.model

    include ActiveModel::Model
    include ActiveModel::Serialization
  end
end
