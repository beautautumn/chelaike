module CompanySerializer
  class SyncCheRongYi < ActiveModel::Serializer
    attributes :id

    has_many :cars, serializer: CarSerializer::DetailWithoutAuthority

    def initialize(object, options={})
      super
      @instance_options[:company_domain_hash]["domain_#{object.id}"] = weshop_domain
    end

    def weshop_domain
      Car::WeshopService.new.official_company_domain(object.id)
    end
  end
end
