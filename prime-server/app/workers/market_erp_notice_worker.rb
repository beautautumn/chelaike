class MarketERPNoticeWorker
  include Sidekiq::Worker
  sidekiq_options retry: 10

  def perform(car_id)
    car = Car.with_deleted.find(car_id)
    company = car.company

    return unless company.erp_url.present?

    data = ActiveModel::Serializer::Adapter::Json.new(
      CarSerializer::Common.new(car, root: "data", include: "**", scope: car.company.owner)
    ).to_json

    RestClient.post(company.erp_url, info: data)
  end
end
