module ErrorCollector
  module Handler
    def full_errors(object, options = {})
      key = options[:key] || object.class.name.underscore

      human_model_name = object.class.model_name.human
      errors_hash = object.errors.to_hash(object.errors.full_messages)
                          .inject({}) do |hash, (class_name, error_messages)|
        hash.tap do
          hash[class_name] = error_messages.map do |error_message|
            "#{human_model_name}#{error_message}"
          end
        end
      end

      errors_hash.present? ? { key => errors_hash } : {}
    end
  end

  include Handler

  attr_reader :fallible_objects

  def fallible(*objects)
    check_up(objects)

    @fallible_objects ||= []
    @fallible_objects = @fallible_objects.concat(objects).uniq
  end

  def hand_over(service)
    fallible(*service.fallible_objects)

    service.fallible_objects.each do |object|
      raise(ActiveRecord::RecordInvalid, object) unless object.valid?
    end
  end

  def valid?
    errors.empty?
  end

  def invalid?
    !valid?
  end

  def errors
    @fallible_objects ||= []
    @fallible_objects.inject({}) do |errors, object|
      errors.tap do |hash|
        hash.merge!(full_errors(object))
      end
    end.with_indifferent_access
  end

  def check_up(objects)
    objects.each do |object|
      raise "Object can't not be blank" if object.blank?
    end
  end
end
