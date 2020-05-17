class EasyLoan::RegionsController < ApplicationController
  serialization_scope :anonymous
  skip_before_action :authenticate_user!
  before_action :skip_authorization

  def provinces
    provinces = Province.all.order_by_pinyin
    render json: provinces,
           each_serializer: RegionSerializer::Province,
           root: "data"
  end

  def cities
    province = Province.find_by(name: params.fetch(:province, {}).fetch(:name, ""))

    cities = province ? province.cities.order_by_pinyin : []

    render json: cities,
           each_serializer: RegionSerializer::City,
           root: "data"
  end
end
