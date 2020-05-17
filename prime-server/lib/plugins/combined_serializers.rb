class CombinedSerializers
  include ActiveModel::Model

  alias read_attribute_for_serialization send

  def initialize(hash)
    hash.each do |name, object|
      instance_variable_set("@#{name}", object)
    end

    self.class.send(:attr_reader, *hash.keys)
  end
end
