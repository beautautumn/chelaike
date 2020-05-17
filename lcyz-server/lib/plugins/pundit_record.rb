class PunditRecord
  attr_reader :policy_class

  def initialize(policy_class, hash = {})
    @policy_class = policy_class

    hash.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    self.class.send(:attr_reader, *hash.keys)
  end
end
