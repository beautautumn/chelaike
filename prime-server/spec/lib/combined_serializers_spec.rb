require "rails_helper"

RSpec.describe CombinedSerializers do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }

  module TestCombinedSerializers
    class Common < ActiveModel::Serializer
      has_one :user, serializer: UserSerializer::Basic
      has_one :company, serializer: CompanySerializer::Common
    end
  end

  describe ".new" do
    it "combines serializer together" do
      combined_serializers = CombinedSerializers.new(
        user: zhangsan,
        company: tianche
      )

      result = ActiveModel::Serializer::Adapter::Json.new(
        TestCombinedSerializers::Common.new(combined_serializers, root: "data")
      ).serializable_hash[:data]

      expect(result).to have_key(:user)
      expect(result).to have_key(:company)
    end
  end
end
