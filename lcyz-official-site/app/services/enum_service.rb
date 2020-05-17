# frozen_string_literal: true
class EnumService
  def self.fetch_enums(type_code)
    enum_type = EnumType.find_by(code: type_code)
    return nil unless enum_type
    Rails.cache.fetch(enum_cache_key(type_code), expires_in: 10.minutes) do
      enum_type.enum_values
    end
  end

  def self.find_enum(type_code, value)
    enums = fetch_enums(type_code)
    return unless enums
    enums.select { |e| e.value == value }.first
  end

  private_class_method def self.enum_cache_key(type_code)
    "site/enums/#{type_code}"
  end
end
