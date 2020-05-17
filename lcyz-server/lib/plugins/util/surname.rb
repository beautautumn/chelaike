module Util
  class Surname
    def self.first_letter(name)
      return if name.blank?

      value = surname_table(name)
      return value if value.present?

      pinyin = Pinyin.t(name) { |letters, i| letters[0].upcase if i == 0 }

      pinyin.blank? ? "" : pinyin
    end

    def self.surname_table(name)
      config = Rails.cache.fetch("SURNAME_TABLE") do
        YAML.load_file("#{Rails.root}/config/surname.yml")
            .to_json
      end
      config = JSON.parse(config).with_indifferent_access

      config[:first_letter].each do |letter, fields|
        fields.each do |field|
          return letter if name == field
        end
      end

      nil
    end
  end
end
