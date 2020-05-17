class PublishCarWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5, queue: :car_publisher

  def perform(user_id, platform, car_id, extra_attrs, contactor_value)
    service = Publisher::PublishService.new(user_id, platform)
    service.create(car_id, extra_attrs, contactor_value)
  end
end
