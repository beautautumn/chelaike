module Util
  class Brand
    def self.to_pinyin(name)
      return if name.blank?

      Pinyin.t(name.gsub(/·/, "")) { |letters, i| letters[0] if i == 0 }
            .try(:first)
    end
  end
end
