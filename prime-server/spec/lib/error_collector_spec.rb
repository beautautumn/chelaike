require "rails_helper"

RSpec.describe ErrorCollector do
  describe "错误收集模块" do
    before do
      class AnyClass
        include ErrorCollector

        def initialize(user, company)
          @user = user
          @company = company

          fallible @user, @company
        end

        def save
          @user.save
          @company.save

          self
        end

        def add_othor_fallibe
          fallible Car.new, @user
        end
      end
    end

    it "指定错误收集对象" do
      expect(AnyClass.new(User.new, Company.new).fallible_objects.size).to eq 2
    end

    it "可多次指定错误收集对象, 并排除重复对象" do
      any_class = AnyClass.new(User.new, Company.new)
      any_class.add_othor_fallibe
      expect(any_class.fallible_objects.size).to eq 3
    end

    it "验证对象有错误" do
      service = AnyClass.new(User.new, Company.new).save
      expect(service.invalid?).to be_truthy
      expect(service.valid?).to be_falsey
    end

    it "获取错误消息" do
      service = AnyClass.new(User.new, Company.new).save

      expect(service.errors[:user]).to be_present
    end
  end
end
