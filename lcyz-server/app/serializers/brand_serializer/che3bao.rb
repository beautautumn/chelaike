# rubocop:disable Style/MethodName
module BrandSerializer
  class Che3bao < ActiveModel::Serializer
    attributes :brandCode, :brandName, :brandPinYin, :brandFirstLetter

    def brandName
      object[:name]
    end

    def brandCode
      brandName
    end

    def brandFirstLetter
      object[:first_letter]
    end

    def brandPinYin
      Pinyin.t(brandName)
    end
  end
end
# rubocop:enable Style/MethodName
