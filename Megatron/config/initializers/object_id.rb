# http://stackoverflow.com/questions/25967669/how-to-return-mongo-id-as-string-in-json-response
module BSON
  class ObjectId
    def to_json(*args)
      to_s.to_json
    end

    def as_json(*args)
      to_s.as_json
    end
  end
end
