require "rails_helper"

RSpec.describe Car::ViewedCountService do
  fixtures :all

  let(:aodi) { cars(:aodi) }

  describe ".add" do
    it "plus 1 to specific car" do
      expect do
        Car::ViewedCountService.add(aodi.id)
      end.to change { Car.find(aodi.id).viewed_count }.by(1)
    end

    it "returns cache key for specific car" do
      expect(Car::ViewedCountService.cache_key(aodi.id)).to eq "Car::ViewedCountService:#{aodi.id}"
    end
  end
end
