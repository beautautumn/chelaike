module Appropriatable
  extend ActiveSupport::Concern

  # 脏数据
  class MissingAppropriate
    attr_accessor :id
  end

  included do
    define_method :primary_key_name do
      self.class.primary_key
    end

    define_method :primary_key_value do
      send(primary_key_name)
    end

    define_method :appropriate do
      value = RedisClient.current
                         .get("#{self.class.name.underscore}_#{primary_key_value}")
      if value
        class_name, appropriated_id = value.split("_")
        appropriated_object = Object.const_get(class_name)
                                    .find_by(id: appropriated_id)

        return appropriated_object if appropriated_id && appropriated_object
      end

      MissingAppropriate.new
    end

    define_method :appropriate_id do
      appropriate.id
    end

    define_method :appropriate= do |object|
      RedisClient.current.set(
        "#{self.class.name.underscore}_#{primary_key_value}",
        "#{object.class.name}_#{object.id}"
      )
    end
  end
end
